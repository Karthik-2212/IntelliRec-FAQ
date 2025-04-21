from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from model_hybrid import recommend_faqs

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)
@app.get("/faqs/{company}")
async def get_faqs_of_company(company: str, query: str = None):
    try:
        # Get FAQs using your model
        faqs = recommend_faqs(company, query)

        # Return as a JSON response
        return JSONResponse(content={"faqs": faqs}, status_code=200)
    
    except Exception as e:
        # Return an error response with status code 500
        return JSONResponse(content={"error": str(e)}, status_code=500)
