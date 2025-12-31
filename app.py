# from flask import Flask

# app = Flask(__name__)

# @app.route("/")
# def home():
#     return "🚀 DevOps CI/CD Demo App running on AWS!"

# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=5000)

from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>DevOps Demo</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
                color: white;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .container {
                text-align: center;
                background: rgba(0, 0, 0, 0.4);
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            }
            h1 {
                font-size: 2rem;
                margin-bottom: 10px;
            }
            p {
                font-size: 1.1rem;
                opacity: 0.9;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 DevOps CI/CD Demo</h1>
            <p>Application running successfully on AWS EC2</p>
        </div>
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

# docker run -d -p 5000:5000 devops-demo-app