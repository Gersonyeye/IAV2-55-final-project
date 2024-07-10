import os
import subprocess
import sys
import winreg

def find_r_path():
    r_path = None
    try:
        # Abrir la clave del registro donde se almacena la información de R
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r'SOFTWARE\R-core\R') as key:
            # Leer la ruta de instalación de R
            r_path, _ = winreg.QueryValueEx(key, 'InstallPath')
    except FileNotFoundError:
        print("No se encontró la instalación de R en el registro.")
    return r_path

def run_r_script(script_name):
    # Buscar la ruta de R
    r_path = find_r_path()
    if not r_path:
        raise FileNotFoundError("R no está instalado o no se encontró en el registro.")

    # Ruta al ejecutable Rscript
    rscript_path = os.path.join(r_path, 'bin', 'Rscript.exe')

    # Ruta del directorio donde está el script de R

    dir_scripts_R = os.path.join(sys.path[-1].split('\\venv')[0],'scripts','Rscripts') 

    # Verificar que Rscript existe
    if not os.path.isfile(rscript_path):
        raise FileNotFoundError(f"El archivo Rscript.exe no se encontró en: {rscript_path}")

    # Construir la ruta relativa al script de R desde el directorio de los scripts de R
    ruta_script_R = os.path.join(dir_scripts_R, script_name)

    # Verificar si el archivo de script de R existe
    if not os.path.isfile(ruta_script_R):
        raise FileNotFoundError(f"El archivo de script de R no se encontró: {ruta_script_R}")

    # Ejecutar el script de R
    try:
        result = subprocess.run([rscript_path, ruta_script_R], check=True, capture_output=True, text=True)
        print(result.stdout)
    except FileNotFoundError:
        print("Rscript no se encuentra en el PATH del sistema. Asegúrate de que R esté instalado y Rscript esté en el PATH.")
    except subprocess.CalledProcessError as e:
        print(f"El script de R falló con el siguiente error:\n{e.stderr}")