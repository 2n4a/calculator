import dotenv
dotenv.load_dotenv(dotenv.find_dotenv())

import uvicorn
import fastapi.middleware.cors
import logging
import os

from routes.calculate import router as calculate_router
from routes.history import router as history_router
from routes.liveness import router as liveness_router


logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(name)s %(message)s',
)
logger = logging.getLogger("calculator")

app = fastapi.FastAPI()

@app.on_event("startup")
async def startup_event():
    logger.info("Calculator backend application is starting up.")

app.add_middleware(
    fastapi.middleware.cors.CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(liveness_router)
app.include_router(calculate_router)
app.include_router(history_router)

if __name__ == "__main__":
    logger.info("Starting uvicorn server...")
    uvicorn.run(app, host="127.0.0.1", port=8000)
