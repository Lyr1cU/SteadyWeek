# Фаза 3 — отчёт (ассистент)

Дата: 2026-09-09  
Статус: реализовано, проверено вручную (backend + Expo Go)

---

## Цель фазы

Лёгкий ассистент по **сегодняшней рутине**: онлайн — Groq через Nest; офлайн / ошибка / лимит — локальные шаблоны. История чата только на устройстве.

См. также: [`docs/DEV_PLAN.md`](../DEV_PLAN.md) §5.

---

## Сервер (Nest)

- Модуль **Assistant**: `POST /assistant/chat` (JWT)
- Тело запроса: `{ message, dayKey }` → `{ reply, source: 'groq' | 'template' }` (`dayKey` обязателен, `yyyy-MM-dd`)
- Контекст для Groq = пункты рутины на `dayKey` из **Neon** (не вся БД, не SQLite клиента)
- `GROQ_API_KEY` только в `backend/.env` (gitignored)
- Rate limit на пользователя: `ASSISTANT_RATE_LIMIT_PER_MIN` (по умолчанию 10)
- Модель по умолчанию: **`openai/gpt-oss-20b`** (`GROQ_MODEL` в `.env`)
- Без ключа, при 429 от Groq или любой ошибке API — ответ из шаблонов, `source: 'template'`

### Эндпоинт

| Метод | Путь | Описание |
|-------|------|----------|
| POST | `/assistant/chat` | Чат ассистента (JWT). Контекст = routine + day statuses на дату |

---

## Клиент (Expo / React Native)

- Локальные шаблоны: `frontend/src/logic/assistant-templates.ts` (работают всегда, в т.ч. офлайн)
- API-клиент: `frontend/src/data/api/assistant.ts`
- Экран чата: `frontend/src/features/assistant/assistant-screen.tsx`
  - Пузыри user / assistant, быстрые подсказки
  - Метка **Groq** / **Template** у ответа
- Вход с экрана **Today** — FAB ✦
- Хук `use-assistant-chat.ts`: логика ответа и состояние чата
- Логика fallback:
  1. есть сеть + залогинен → запрос на backend
  2. ошибка / офлайн / не залогинен → `pickAssistantTemplate()` по **локальному SQLite**
- История сообщений **не синкается** в облако

---

## Нюансы (не блокеры)

1. **Groq смотрит Neon, offline — локальный SQLite.** Если правки ещё не sync’нулись, Groq может ответить не по тому, что на экране. Перед вопросом ассистенту — «Sync now» или дождаться **Synced**.
2. **Ассистент всегда про «сегодня»** (`startOfLocalDay(new Date())`), не про день, который открыт стрелками на Today. Задумано расширить: любой `dayKey` (прошлое/будущее) — после фазы 4 или в фазе 6 вместе с MCP. API уже принимает `dayKey`.
3. **Rate limit на backend** (`ASSISTANT_RATE_LIMIT_PER_MIN`) → HTTP 429 → клиент падает в **локальный** template (не серверный). Работает; контекст может чуть отличаться от Groq-ответа. При 429 от **Groq** backend сам отдаёт серверный шаблон с `source: 'template'`.
4. **История чата — только в памяти** (`useState` в `use-assistant-chat.ts`). Пропадает при Back с экрана и при перезапуске приложения. По плану ок.

---

## Дебагинг при тестах

| Проблема | Причина | Решение |
|----------|---------|---------|
| Ответы только с меткой **Template** | Groq вернул 404: модель `llama-3.1-8b-instant` снята с free/dev tier (16.08.2026) | Дефолт заменён на `openai/gpt-oss-20b` |
| «Не работает из‑за порта 8082» | Expo (8081/8082) и API (3000) — разные сервисы | Ассистент ходит на `EXPO_PUBLIC_API_URL` → `:3000`, порт Metro не влияет |
| Нужны ли кавычки у `GROQ_API_KEY` | Нет — dotenv читает ключ без кавычек | Достаточно `GROQ_API_KEY=gsk_...` |
| QR-код не виден в терминале Cursor | Фоновый терминал не интерактивный | `npm start` в своём PowerShell или URL `exp://<LAN-IP>:8082` в Expo Go |

---

## Groq (тариф)

- **Free tier** без карты: лимиты ~30 req/min, ~1000 req/day на модель — для личного использования достаточно
- При 429 от Groq backend отдаёт серверный шаблон; при 429 от нашего rate limit — клиентский fallback (см. нюансы выше)
- Ключ хранить только в `backend/.env`; при утечке — перевыпустить в [console.groq.com](https://console.groq.com)

---

## Проверено вручную

- [x] `POST /assistant/chat` с JWT → `source: 'groq'` (после смены модели на `openai/gpt-oss-20b`)
- [x] Backend health + CORS, `EXPO_PUBLIC_API_URL` с LAN IP
- [x] Expo Go: сборка Android, экран Assistant открывается с Today
- [x] Залогинен + wifi → метка **Groq** (после фикса модели)

---

## Чеклист «фаза 3 закрыта» (ещё прогнать)

- [x] Залогинен + wifi → вопрос «What's on today?» → метка **Groq**, ответ по пунктам
- [ ] Airplane mode → тот же вопрос → **Template**, без краша
- [ ] Не залогинен → шаблоны по локальному SQLite
- [ ] 11+ запросов за минуту → 429 → fallback на шаблон (локальный или серверный — см. нюансы)

---

## Ключевые пути в репо

| Область | Путь |
|---------|------|
| Assistant module | `backend/src/assistant/` |
| Шаблоны (сервер) | `backend/src/assistant/assistant-templates.ts` |
| Шаблоны (клиент) | `frontend/src/logic/assistant-templates.ts` |
| API client | `frontend/src/data/api/assistant.ts` |
| UI чата | `frontend/src/features/assistant/assistant-screen.tsx` |
| Логика чата | `frontend/src/features/assistant/use-assistant-chat.ts` |
| Env-пример | `backend/.env.example` (`GROQ_API_KEY`, `GROQ_MODEL`) |

---

## Не делали (следующие фазы)

- Цели недели, закрытие дня, недельный отчёт (фаза 4)
- XP, магазин, косметика ассистента (фаза 5)
- MCP-tools (фаза 6)
- Сохранение истории чата в Neon
