import os
import sys
import socket
import threading
import asyncio
import logging
import json
import datetime

# === ☢️ ЯДЕРНЫЙ ФИКС DNS (HARDCORE PATCH) ===
# Мы вручную говорим боту, где находится Telegram, минуя сломанный DNS сервера
TELEGRAM_IP = "149.154.167.220"  # Прямой IP сервера api.telegram.org

# Сохраняем настоящий сокет
original_getaddrinfo = socket.getaddrinfo

def patched_getaddrinfo(host, port, family=0, type=0, proto=0, flags=0):
    # Если бот ищет Телеграм, даем ему IP напрямую
    if host == "api.telegram.org":
        # print(f"⚡️ DNS Bypass: Перенаправляю api.telegram.org на {TELEGRAM_IP}")
        return [(socket.AF_INET, socket.SOCK_STREAM, 6, '', (TELEGRAM_IP, port))]
    # Для всего остального используем стандартный метод
    return original_getaddrinfo(host, port, family, type, proto, flags)

# Подменяем функцию в системе
socket.getaddrinfo = patched_getaddrinfo
# ============================================

# Установка библиотек (если их нет)
try:
    import aiogram
    import gradio
    import openai
except ImportError:
    os.system("pip install aiogram aiohttp openai gradio")

from aiogram import Bot, Dispatcher, types, F
from aiogram.filters import Command, CommandObject
from aiogram.types import InlineKeyboardMarkup, InlineKeyboardButton, ChatPermissions
from openai import AsyncOpenAI

# ================= ⚙️ НАСТРОЙКИ =================
API_TOKEN = '7807742774:AAE2scI1PcTW-aOVHaBkfLKZ3YTSRE0IzYk'
OPENAI_API_KEY = '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'

AI_MODEL = "gpt-4o"
TRIGGERS_FILE = "trigger.json"

logging.basicConfig(level=logging.INFO, stream=sys.stdout)

bot = Bot(token=API_TOKEN)
dp = Dispatcher()
client = None

if OPENAI_API_KEY:
    try:
        client = AsyncOpenAI(api_key=OPENAI_API_KEY)
    except: pass

config = {
    "triggers": set(),
    "mute_time": 60,
    "punishment": "mute"
}

# ================= 📂 ФУНКЦИИ =================

def load_triggers():
    if not os.path.exists(TRIGGERS_FILE): return set()
    try:
        with open(TRIGGERS_FILE, "r", encoding="utf-8") as f:
            return set(json.load(f))
    except: return set()

def save_triggers():
    try:
        with open(TRIGGERS_FILE, "w", encoding="utf-8") as f:
            json.dump(list(config["triggers"]), f, ensure_ascii=False)
    except: pass

async def is_admin(chat_id, user_id):
    try:
        member = await bot.get_chat_member(chat_id, user_id)
        return member.status in ["administrator", "creator"]
    except: return False

def get_kb():
    return InlineKeyboardMarkup(inline_keyboard=[
        [InlineKeyboardButton(text=f"⏳ Мут: {config['mute_time']} мин", callback_data="ignore")],
        [InlineKeyboardButton(text="➕ 10", callback_data="add"), InlineKeyboardButton(text="➖ 10", callback_data="sub")],
        [InlineKeyboardButton(text=f"🔨 {config['punishment']}", callback_data="mode")],
        [InlineKeyboardButton(text="❌ Закрыть", callback_data="del")]
    ])

# ================= 📜 ХЕНДЛЕРЫ =================

@dp.message(Command("start"))
async def start(msg: types.Message):
    await msg.answer("👋 Blackwood Bot: Связь установлена (DNS Bypass).")

@dp.message(Command("m"))
async def menu(msg: types.Message):
    if await is_admin(msg.chat.id, msg.from_user.id):
        await msg.answer("⚙️ Меню:", reply_markup=get_kb())

@dp.message(Command("karma"))
async def karma(msg: types.Message, cmd: CommandObject):
    if not await is_admin(msg.chat.id, msg.from_user.id): return
    args = cmd.args.split() if cmd.args else []
    if not args:
        txt = ", ".join(config["triggers"]) if config["triggers"] else "Пусто"
        await msg.answer(f"📝 {txt}")
        return
    act, w = args[0].lower(), args[1].lower() if len(args)>1 else ""
    if act=="add" and w:
        config["triggers"].add(w); save_triggers()
        await msg.answer(f"✅ +{w}")
    elif act=="del" and w:
        config["triggers"].discard(w); save_triggers()
        await msg.answer(f"🗑 -{w}")

@dp.message(Command("pardon"))
async def pardon(msg: types.Message):
    if not await is_admin(msg.chat.id, msg.from_user.id): return
    if msg.reply_to_message:
        try:
            await bot.restrict_chat_member(msg.chat.id, msg.reply_to_message.from_user.id, ChatPermissions(can_send_messages=True))
            await msg.answer("😇")
        except: pass

@dp.callback_query()
async def callback(call: types.CallbackQuery):
    if not await is_admin(call.message.chat.id, call.from_user.id): return
    d = call.data
    global config
    if d=="add": config["mute_time"]+=10
    elif d=="sub": config["mute_time"]=max(10, config["mute_time"]-10)
    elif d=="mode": config["punishment"]=["mute","kick","ban"][(["mute","kick","ban"].index(config["punishment"])+1)%3]
    elif d=="del": await call.message.delete(); return
    await call.message.edit_reply_markup(reply_markup=get_kb())

@dp.message(F.text | F.caption)
async def check(msg: types.Message):
    if msg.text and msg.text.startswith("/"): return
    if await is_admin(msg.chat.id, msg.from_user.id): return
    txt = (msg.text or msg.caption or "").lower()
    violation = False
    for w in config["triggers"]:
        if w in txt: violation=True
    if not violation and client and len(txt)>3:
        try:
            resp = await client.chat.completions.create(model=AI_MODEL, messages=[{"role":"user","content":f"Мат/агрессия? YES/NO: {txt}"}], max_tokens=2)
            if "YES" in resp.choices[0].message.content: violation=True
        except: pass
    if violation:
        try: await msg.delete()
        except: pass
        info = await msg.answer(f"👮‍♂️ Нарушение! {msg.from_user.first_name}")
        try:
            uid = msg.from_user.id
            if config["punishment"]=="mute":
                until = datetime.datetime.now()+datetime.timedelta(minutes=config["mute_time"])
                await bot.restrict_chat_member(msg.chat.id, uid, ChatPermissions(can_send_messages=False), until_date=until)
                await info.edit_text(f"🤐 Мут {config['mute_time']} мин.")
            elif config["punishment"]=="ban":
                await bot.ban_chat_member(msg.chat.id, uid); await info.edit_text("⛔️ Бан")
            elif config["punishment"]=="kick":
                await bot.ban_chat_member(msg.chat.id, uid); await bot.unban_chat_member(msg.chat.id, uid); await info.edit_text("👋 Кик")
        except: pass

# ================= 🚀 ЗАПУСК =================

async def bot_main():
    print("🚀 Бот (v. Hardcore DNS) запускается...")
    config["triggers"] = load_triggers()
    await bot.delete_webhook(drop_pending_updates=True)
    await dp.start_polling(bot, handle_signals=False)

def run_thread():
    try: asyncio.run(bot_main())
    except Exception as e: print(f"❌ ERR: {e}")

if __name__ == "__main__":
    t = threading.Thread(target=run_thread, daemon=True)
    t.start()
    
    import gradio as gr
    iface = gr.Interface(fn=lambda x: "OK", inputs="text", outputs="text", title="Blackwood")
    iface.launch(server_name="0.0.0.0", server_port=7860)
