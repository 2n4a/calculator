# Backend

## Установка

Из корня репозитория:
```shell
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
Если добавляете зависимости, не забудьте проверить, что
виртуальное окружение активировано. После установки зависимостей
не забудьте записать изменения в `requirements.txt` (из корня):
```shell
pip freeze > requirements.txt
```

## Запуск

```shell
cd backend
fastapi dev main.py
```

чтобы запустить продуктовую сборку:
```shell
fastapi run main.py
```
