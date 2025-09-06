import dotenv
import fastapi.middleware.cors
from starlette.responses import FileResponse
from starlette.staticfiles import StaticFiles

from routes.calculate import router as calculate_router
from routes.history import router as history_router
from routes.liveness import router as liveness_router

dotenv.load_dotenv()


app = fastapi.FastAPI()

app.mount("/static", StaticFiles(directory="../frontend/static"), name="static")

app.add_middleware(
    fastapi.middleware.cors.CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def index():
    return FileResponse("../frontend/static/index.html")

app.include_router(liveness_router)
app.include_router(calculate_router)
app.include_router(history_router)
