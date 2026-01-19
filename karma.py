import asyncio
import logging
import datetime
import base64
import io
import json
import os
from aiogram import Bot, Dispatcher, types, F
from aiogram.filters import Command, CommandObject
from aiogram.types import InlineKeyboardMarkup, InlineKeyboardButton, ChatPermissions, BotCommand
from openai import AsyncOpenAI

# ================= ⚙️ КОНФИГУРАЦИЯ =================
API_TOKEN = '7807742774:AAE2scI1PcTW-aOVHaBkfLKZ3YTSRE0IzYk'
OPENAI_API_KEY = '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'

AI_MODEL = "gpt-4o"

# Имена файлов
TRIGGERS_FILE = "trigger.json"
LOGS_FILE = "logs.txt"

logging.basicConfig(level=logging.INFO)

bot = Bot(token=API_TOKEN)
dp = Dispatcher()
client = None

if OPENAI_API_KEY and len(OPENAI_API_KEY) > 10:
    client = AsyncOpenAI(api_key=OPENAI_API_KEY)
else:
    print("⚠️ OpenAI ключ не найден. ИИ выключен.")

# База настроек (в памяти)
config = {
    "triggers": set(),
    "mute_time": 60,
    "punishment": "mute"
}

# ================= 📂 РАБОТА С ФАЙЛАМИ =================

def load_triggers():
    """Загружает триггеры из JSON при запуске"""
    if not os.path.exists(TRIGGERS_FILE):
        return set()
    try:
        with open(TRIGGERS_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
            return set(data)
    except Exception as e:
        print(f"Ошибка чтения JSON: {e}")
        return set()

def save_triggers():
    """Сохраняет текущий список триггеров в JSON"""
    try:
        with open(TRIGGERS_FILE, "w", encoding="utf-8") as f:
            # Превращаем set в list, так как JSON не понимает set
            json.dump(list(config["triggers"]), f, ensure_ascii=False, indent=4)
    except Exception as e:
        print(f"Ошибка сохранения JSON: {e}")

def log_to_file(message: types.Message):
    """Записывает сообщение в logs.txt"""
    try:
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        user = f"{message.from_user.first_name} (ID: {message.from_user.id})"
        
        content = "[Неизвестно]"
        if message.text:
            content = message.text
        elif message.photo:
            content = "[ФОТО]"
            if message.caption:
                content += f" Подпись: {message.caption}"
        
        log_line = f"[{timestamp}] {user}: {content}\n"
        
        with open(LOGS_FILE, "a", encoding="utf-8") as f:
            f.write(log_line)
    except Exception as e:
        print(f"Ошибка логирования: {e}")

# ================= 🛠 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =================

async def is_user_admin(chat_id, user_id):
    try:
        member = await bot.get_chat_member(chat_id, user_id)
        return member.status in ["administrator", "creator"]
    except:
        return False

async def set_commands(bot: Bot):
    commands = [
        BotCommand(command="start", description="👋 Меню"),
        BotCommand(command="help", description="📖 Инфо"),
        BotCommand(command="m", description="⚙️ Настройки"),
        BotCommand(command="karma", description="📝 Слова"),
        BotCommand(command="pardon", description="😇 Разбан"),
    ]
    await bot.set_my_commands(commands)

# ================= ⌨️ КЛАВИАТУРЫ =================

def get_main_keyboard():
    return InlineKeyboardMarkup(inline_keyboard=[
        [InlineKeyboardButton(text="⚙️ Настройки", callback_data="open_settings")],
        [InlineKeyboardButton(text="📖 Помощь", callback_data="send_help_text")]
    ])

def get_settings_keyboard():
    return InlineKeyboardMarkup(inline_keyboard=[
        [InlineKeyboardButton(text=f"⏳ Мут: {config['mute_time']} мин", callback_data="ignore")],
        [InlineKeyboardButton(text="➕ 10 мин", callback_data="add_time_10"),
         InlineKeyboardButton(text="➖ 10 мин", callback_data="sub_time_10")],
        [InlineKeyboardButton(text=f"🔨 Тип: {config['punishment']}", callback_data="toggle_punishment")],
        [InlineKeyboardButton(text="📝 Список слов", callback_data="list_triggers")],
        [InlineKeyboardButton(text="🔙 Закрыть", callback_data="delete_msg")]
    ])

# ================= 📜 КОМАНДЫ =================

@dp.message(Command("start"))
async def cmd_start(message: types.Message):
    await message.answer("👋 Я ИИ-Модератор с сохранением логов.", reply_markup=get_main_keyboard())

@dp.message(Command("help"))
async def cmd_help(message: types.Message):
    text = (
        "📖 **ИНФО**\n"
        "1. Триггеры сохраняются в `trigger.json`.\n"
        "2. Логи чата пишутся в `logs.txt`.\n"
        "3. `/karma add [слово]` - добавить запрет.\n"
        "4. `/pardon` (ответ на сообщение) - разбанить."
    )
    await message.answer(text, parse_mode="Markdown")

@dp.message(Command("m"))
async def cmd_settings(message: types.Message):
    if not await is_user_admin(message.chat.id, message.from_user.id):
        return await message.answer("⛔️ Только админы.")
    await message.answer("⚙️ Настройки:", reply_markup=get_settings_keyboard())

@dp.message(Command("karma"))
async def cmd_karma(message: types.Message, command: CommandObject):
    if not await is_user_admin(message.chat.id, message.from_user.id):
        return await message.answer("⛔️ Только админы.")

    if command.args is None:
        triggers = ", ".join(config["triggers"]) if config["triggers"] else "Пусто"
        await message.answer(f"📝 Список: `{triggers}`", parse_mode="Markdown")
        return
    
    args = command.args.split()
    action = args[0].lower()
    word = args[1].lower() if len(args) > 1 else ""
    
    if action == "add" and word:
        config["triggers"].add(word)
        save_triggers() # <--- СОХРАНЯЕМ В ФАЙЛ
        await message.answer(f"✅ Слово **{word}** сохранено в trigger.json", parse_mode="Markdown")
    elif action == "del" and word:
        config["triggers"].discard(word)
        save_triggers() # <--- ОБНОВЛЯЕМ ФАЙЛ
        await message.answer(f"🗑 Слово **{word}** удалено из файла.", parse_mode="Markdown")

@dp.message(Command("pardon"))
async def cmd_pardon(message: types.Message, command: CommandObject):
    if not await is_user_admin(message.chat.id, message.from_user.id): return

    user_id = None
    if message.reply_to_message:
        user_id = message.reply_to_message.from_user.id
    elif command.args and command.args.isdigit():
        user_id = int(command.args)
    
    if user_id:
        try:
            await bot.unban_chat_member(message.chat.id, user_id, only_if_banned=True)
            await bot.restrict_chat_member(
                message.chat.id, user_id,
                permissions=ChatPermissions(can_send_messages=True, can_send_media_messages=True, can_send_other_messages=True)
            )
            await message.answer(f"😇 Разбанен ID {user_id}")
        except:
            await message.answer("Ошибка разбана.")

# ================= 🖱 КНОПКИ =================

@dp.callback_query()
async def process_callback(callback: types.CallbackQuery):
    if not await is_user_admin(callback.message.chat.id, callback.from_user.id):
        await callback.answer("⛔️ Ты не админ!", show_alert=True)
        return

    global config
    data = callback.data
    
    if data.startswith("pardon_"):
        user_id = int(data.split("_")[1])
        try:
            await bot.unban_chat_member(callback.message.chat.id, user_id, only_if_banned=True)
            await bot.restrict_chat_member(
                callback.message.chat.id, user_id,
                permissions=ChatPermissions(can_send_messages=True, can_send_media_messages=True, can_send_other_messages=True)
            )
            await callback.message.edit_text(f"😇 Помилован админом {callback.from_user.first_name}.")
        except:
            await callback.answer("Ошибка", show_alert=True)
        return

    if data == "open_settings":
        await callback.message.edit_text("⚙️ Настройки:", reply_markup=get_settings_keyboard())
    elif data == "send_help_text":
        await cmd_help(callback.message)
    elif data == "delete_msg":
        await callback.message.delete()
    elif data == "list_triggers":
        txt = ", ".join(config["triggers"]) if config["triggers"] else "Пусто"
        await callback.answer(txt[:200], show_alert=True)
    elif data == "add_time_10":
        config["mute_time"] += 10
        await callback.message.edit_reply_markup(reply_markup=get_settings_keyboard())
    elif data == "sub_time_10":
        config["mute_time"] = max(1, config["mute_time"] - 10)
        await callback.message.edit_reply_markup(reply_markup=get_settings_keyboard())
    elif data == "toggle_punishment":
        modes = ["mute", "kick", "ban"]
        config["punishment"] = modes[(modes.index(config["punishment"]) + 1) % len(modes)]
        await callback.message.edit_reply_markup(reply_markup=get_settings_keyboard())
    
    if data not in ["list_triggers", "send_help_text"]: await callback.answer()

# ================= 🧠 AI ЛОГИКА =================

async def analyze_text_ai(text):
    if not client: return False
    try:
        response = await client.chat.completions.create(
            model=AI_MODEL,
            messages=[
                {"role": "system", "content": "Ты модератор. Ответь YES если текст содержит мат, агрессию, угрозы. Иначе NO."},
                {"role": "user", "content": text}
            ],
            max_tokens=5
        )
        return "YES" in response.choices[0].message.content.strip().upper()
    except Exception as e:
        print(f"AI Error: {e}")
        return False

async def analyze_image_ai(photo_file_id, bot_instance):
    if not client: return False
    try:
        file_info = await bot_instance.get_file(photo_file_id)
        file_stream = io.BytesIO()
        await bot_instance.download_file(file_info.file_path, destination=file_stream)
        base64_image = base64.b64encode(file_stream.getvalue()).decode('utf-8')
        
        response = await client.chat.completions.create(
            model=AI_MODEL,
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": "Ты модератор. Если на фото порно, насилие или оскорбления - ответь YES. Иначе NO."},
                        {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}}
                    ]
                }
            ],
            max_tokens=5
        )
        return "YES" in response.choices[0].message.content.strip().upper()
    except:
        return False

# ================= 🛡 ГЛАВНЫЙ ОБРАБОТЧИК =================

@dp.message(F.text | F.photo | F.caption)
async def unified_handler(message: types.Message):
    # 1. ЛОГИРОВАНИЕ (Пишем в файл logs.txt)
    log_to_file(message)
    
    if message.text and message.text.startswith("/"): return
    
    user_id = message.from_user.id
    chat_id = message.chat.id
    
    # Иммунитет админа
    if await is_user_admin(chat_id, user_id):
        return 

    text_content = message.text or message.caption or ""
    text_lower = text_content.lower()
    violation_found = False
    reason = ""

    # Проверка слов
    for trigger in config["triggers"]:
        if trigger in text_lower:
            violation_found = True
            reason = f"Слово '{trigger}'"
            break
            
    # AI Текст
    if not violation_found and text_content and len(text_content) > 1 and client:
        if await analyze_text_ai(text_content):
            violation_found = True
            reason = "AI (Агрессия)"

    # AI Фото
    if not violation_found and message.photo and client:
        status_msg = await message.reply("👁 AI Проверка...")
        if await analyze_image_ai(message.photo[-1].file_id, bot):
            violation_found = True
            reason = "AI Vision (Фото)"
        try: await status_msg.delete() 
        except: pass

    # Наказание
    if violation_found:
        try: await message.delete()
        except: pass 
        
        info_msg = await message.answer(f"👮‍♂️ **НАРУШЕНИЕ!**\n👤 {message.from_user.first_name}\n❓ {reason}", parse_mode="Markdown")
        await asyncio.sleep(1)
        await apply_punishment(user_id, chat_id, info_msg)

async def apply_punishment(user_id, chat_id, info_msg):
    mode = config["punishment"]
    pardon_kb = InlineKeyboardMarkup(inline_keyboard=[[InlineKeyboardButton(text="😇 Разбанить", callback_data=f"pardon_{user_id}")]])
    
    try:
        if mode == "mute":
            until = datetime.datetime.now() + datetime.timedelta(minutes=config["mute_time"])
            await bot.restrict_chat_member(chat_id, user_id, ChatPermissions(can_send_messages=False), until_date=until)
            await info_msg.edit_text(f"🤐 **МУТ {config['mute_time']} мин**\nСообщение удалено.", reply_markup=pardon_kb)
        elif mode == "ban":
            await bot.ban_chat_member(chat_id, user_id)
            await info_msg.edit_text(f"⛔️ **БАН**\nСообщение удалено.", reply_markup=pardon_kb)
        elif mode == "kick":
            await bot.ban_chat_member(chat_id, user_id)
            await bot.unban_chat_member(chat_id, user_id)
            await info_msg.edit_text(f"👋 **КИК**\nСообщение удалено.", reply_markup=pardon_kb)
    except Exception as e:
        await info_msg.edit_text(f"⚠️ Нет прав админа! {e}")

# ================= 🚀 ЗАПУСК =================
async def main():
    print("Бот запущен!")
    
    # ЗАГРУЗКА ТРИГГЕРОВ ИЗ ФАЙЛА
    config["triggers"] = load_triggers()
    print(f"Загружено триггеров: {len(config['triggers'])}")
    
    await set_commands(bot)
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
