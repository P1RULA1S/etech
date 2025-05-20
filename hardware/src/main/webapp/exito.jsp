<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Acción Exitosa | E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <style>
        .success-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 70vh;
            text-align: center;
            padding: 0 20px;
        }
        
        .success-message {
            font-family: 'Ethnocentric Rg', sans-serif;
            font-size: 3.5rem;
            color: #2a9d8f;
            margin-bottom: 2rem;
            text-shadow: 
                0 0 10px rgba(42, 157, 143, 0.5),
                0 0 20px rgba(42, 157, 143, 0.3);
            animation: pulse 2s infinite;
        }
        
        .success-icon {
            font-size: 5rem;
            color: #2a9d8f;
            margin-bottom: 2rem;
            filter: drop-shadow(0 0 10px rgba(42, 157, 143, 0.5));
        }
        
        .back-link {
            margin-top: 3rem;
            font-family: 'Quantico', sans-serif;
            font-size: 1.2rem;
        }
        
        .back-link a {
            color: #2a9d8f;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            padding: 10px 20px;
            border-radius: 30px;
            border: 2px solid #2a9d8f;
        }
        
        .back-link a:hover {
            background-color: #2a9d8f;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(42, 157, 143, 0.3);
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1 class="success-message">ACCIÓN REALIZADA CON ÉXITO</h1>
        <div class="back-link">
            <a href="index.jsp">
                <i class="fas fa-arrow-left"></i> Volver al inicio
            </a>
        </div>
    </div>
</body>
</html>