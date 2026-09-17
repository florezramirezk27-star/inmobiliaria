<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso denegado | Inmobiliaria</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            font-family: Arial, Helvetica, sans-serif;
            background:
                radial-gradient(circle at top left, #eef4ff, transparent 38%),
                linear-gradient(135deg, #f8fafc, #eef2f7);
            color: #172033;
        }

        .access-card {
            width: 100%;
            max-width: 620px;
            padding: 48px 38px;
            background: #ffffff;
            border-radius: 22px;
            box-shadow: 0 22px 60px rgba(25, 42, 70, 0.12);
            text-align: center;
        }

        .icon {
            width: 78px;
            height: 78px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #fff2f2;
            font-size: 36px;
        }

        .code {
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 3px;
            color: #c0392b;
        }

        h1 {
            margin: 0 0 14px;
            font-size: 32px;
        }

        p {
            max-width: 470px;
            margin: 0 auto;
            line-height: 1.65;
            color: #5d6678;
        }

        .actions {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .btn {
            min-width: 160px;
            padding: 13px 20px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 700;
            transition: transform .15s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: #172033;
            color: #ffffff;
        }

        .btn-secondary {
            background: #eef2f7;
            color: #172033;
        }

        @media (max-width: 600px) {
            .access-card {
                padding: 36px 22px;
            }

            h1 {
                font-size: 27px;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<main class="access-card">
    <div class="icon">🔒</div>

    <div class="code">ERROR 403</div>

    <h1>Acceso denegado</h1>

    <p>
        Tu sesión está activa, pero tu usuario no tiene permisos
        para acceder a esta sección del sistema.
    </p>

    <div class="actions">
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/index">
            Volver al inicio
        </a>

        <a class="btn btn-secondary"
           href="${pageContext.request.contextPath}/propiedades">
            Ver propiedades
        </a>
    </div>
</main>

</body>
</html>
