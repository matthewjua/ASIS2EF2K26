# Examen final Serie IV · Matthew Juárez · 0901-23-4250

El repositorio guarda los cambios versionados del examen y la revisión exacta del proyecto público Embutidos de Calidad. El script aplica la solución sobre esa revisión.

```powershell
powershell -ExecutionPolicy Bypass -File .\Preparar.ps1
powershell -ExecutionPolicy Bypass -File .\Compilar.ps1 -Configuracion Release
```

La primera compilación prepara las bibliotecas del proyecto de clase; puede tardar varios minutos.

Si ya tiene una copia Git del proyecto de clase con esa revisión, use el argumento `-BaseLocal` con su ruta para reutilizar sus archivos. La solución de Visual Studio queda en `codigo/modulos/ventas/Ejecutable_Ventas/Ejecucion_Ventas.sln`. En la rama de Mantenimientos, `EmbutidosExamen/examen-final/README.md` explica la instalación de la base y la demostración.
