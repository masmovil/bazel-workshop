## Guion para el Instructor

### 1. Introducción (0:00 - 0:05)

> **Instructor**:  
> “¡Bienvenidas y bienvenidos al Workshop de Bazel! A lo largo de estas 2 horas, aprenderemos a utilizar reglas en Bazel, desde el uso sencillo de `genrule` hasta la creación de reglas y macros personalizadas en Starlark.  
> 
> Partiremos de un archivo JSON (`data.json`) para ilustrar diferentes pasos de build: primero imprimiremos su contenido, luego lo procesaremos (por ejemplo, para convertirlo a CSV), y finalmente crearemos nuestras propias reglas y macros.  
> 
> Siéntanse libres de hacer preguntas en cualquier momento; además, dejaremos un espacio de Q&A al finalizar.”

### 2. Fundamentos de Bazel (0:05 - 0:15)

> **Instructor**:  
> “Antes de iniciar los ejercicios, repasemos algunos conceptos clave sobre la estructura de un proyecto Bazel:  
> - **WORKSPACE**: Marca la raíz del proyecto Bazel y, si es necesario, declara dependencias externas.  
> - **BUILD**: Contiene *targets* que describen cómo se construyen o procesan archivos (reglas, `srcs`, `outs`, etc.).  
> - **Targets y Labels**: Cada regla o macro se considera un ‘target’, y se hace referencia a ellos mediante *labels* (por ejemplo, `//carpeta:target`).  
> 
> Hoy nos centraremos en reglas locales y en la transformación de un archivo JSON. ¡Manos a la obra!”

### 3. Ejercicio 1: Imprimir el Contenido del JSON (0:15 - 0:30)

> **Instructor**:  
> “Empecemos con algo muy sencillo: imprimir el contenido de `data.json` por consola usando `genrule`.  
> 
> Abran el archivo `exercise_1/BUILD` y añadan:
> ```python
> genrule(
>     name = "print_data",
>     srcs = ["//resources:data.json"],  # Hace referencia al archivo en la raíz del proyecto
>     outs = ["print_data.log"],  # Archivo de salida para que Bazel no se queje de salidas inexistentes
>     cmd = "cat $(SRCS) | tee $@",
>     #cmd = "cat $(SRCS) > $(OUTS)",
> )
> ```
> Esta regla ejecuta el comando de shell `cat` para mostrar el contenido de `data.json` y utiliza `tee` para redirigir ese contenido al archivo `print_data.log`. 

Commit solución -> `git cherry-pick 0f499de6a67a98f0375abeb98268774bed7dc74c`

> 
> **Ahora**, construimos este target con:
> ```bash
> bazel build //exercise_1/solution:print_data
> ```
> Revisa la consola: debería mostrar el contenido de `data.json`. Además, en `bazel-bin/simple_genrule/print_data.log` verás el mismo contenido almacenado como archivo de salida.”

### 4. Ejercicio 2: Procesar el Archivo JSON (0:30 - 0:45)

> **Instructor**:  
> “Vamos a dar un paso más y procesar el JSON para generar, por ejemplo, un CSV. Crearemos un script en Python (`process_json.py`) que lea el JSON y lo convierta a CSV.  
> 
> Después, en `simple_genrule/BUILD`, agregamos:
> ```python
> genrule(
>    name = "convert_data_2",
>    srcs = [
>        "//resources:data.json",
>    ],
>    tools = ["//resources:process_json.py"],
>    outs = ["output.csv"],
>    cmd = "python3 resources/process_json.py $(SRCS) $(OUTS)",
>)
> ```
> 
> Al ejecutar:
> ```bash
> bazel build //exercise_2/solution::convert_data
> ```
> se generará el archivo `output.csv` en `bazel-bin/exercise_2/simple_genrule/`. Con esto ya tenemos un ejemplo de cómo usar `genrule` para un script de transformación.”

Commit solución -> `git cherry-pick e1dee194d1e6848d39bdd1c7bab136c1b010fcfb`

### 5. Recapitulación y Preguntas (0:45 - 0:50)

> **Instructor**:  
> “¿Tienen alguna pregunta sobre `genrule`, cómo declaramos `srcs`, `outs` o cómo funciona el campo `cmd`?  
> 
> Hasta ahora, hemos visto dos ejemplos prácticos: uno para imprimir contenido y otro para procesarlo con un script externo. Esto sienta la base para crear reglas más avanzadas.”

*(Espacio para preguntas y aclaraciones.)*

### 6. Ejercicio 3: Creación de una Regla Personalizada en Starlark (0:50 - 1:10)

> **Instructor**:  
> “Ahora pasaremos a **escribir una regla personalizada** usando Starlark, lo que nos da más control y escalabilidad en comparación con `genrule`.  
> 
> 1. Creamos un archivo `rules.bzl` en la raíz del proyecto con la siguiente implementación:
> ```python
> def _my_json_rule_impl(ctx):
>     # Obtenemos el archivo de entrada (JSON)
>     input_file = ctx.file.src
>     # Declaramos la salida (CSV)
>     output_file = ctx.actions.declare_file(ctx.label.name + ".csv")
> 
>     # Ejecutamos el script para transformar JSON a CSV
>     ctx.actions.run(
>         inputs = [input_file, ctx.file._script],
>         outputs = [output_file],
>         arguments = [input_file.path, output_file.path],
>         executable = ctx.executable._script,
>     )
> 
>     return [DefaultInfo(files = depset([output_file]))]
> 
> my_json_rule = rule(
>     implementation = _my_json_rule_impl,
>     attrs = {
>         "src": attr.label(allow_single_file = True),
>         "_script": attr.label(
>             allow_single_file = True,
>             default = "//:process_json.py",
>             executable = True,
>             cfg = "host",
>         ),
>     },
> )
> ```
> 
> 2. En el archivo `BUILD` principal, cargamos la regla y la usamos:
> ```python
> load("//:rules.bzl", "my_json_rule")
> 
> my_json_rule(
>     name = "my_json_to_csv",
>     src = "data.json",
> )
> ```
> 
> 3. Ejecutamos:
> ```bash
> bazel build //:my_json_to_csv
> ```
> y se generará `my_json_to_csv.csv` en `bazel-bin/`.  
> 
> Con esto, hemos visto cómo crear una regla que describe sus propios *inputs*, *outputs* y lógica de build. El script `process_json.py` realiza la transformación, mientras que la regla gestiona la acción dentro del grafo de dependencias de Bazel.”

### 7. Ejercicio 4: Macro que Combina Varias Reglas (1:10 - 1:30)

> **Instructor**:  
> “Para ilustrar aún más la potencia de Bazel, definiremos una **macro** que encadene varios pasos. Por ejemplo, convertir el JSON a CSV y luego comprimir el resultado.  
> 
> En `rules.bzl`, añadimos:
> ```python
> def my_pipeline(name, src):
>     # Paso 1: convertir JSON a CSV con la regla anterior
>     my_json_rule(
>         name = name + "_json_to_csv",
>         src = src,
>     )
> 
>     # Paso 2: comprimir el CSV (usamos una genrule adicional)
>     genrule(
>         name = name + "_compress_csv",
>         srcs = [name + "_json_to_csv"],  # Se refiere a la salida CSV
>         outs = [name + ".zip"],
>         cmd = "zip $@ $(SRCS)",
>     )
> ```
> 
> Después, en nuestro `BUILD`:
> ```python
> load("//:rules.bzl", "my_pipeline")
> 
> my_pipeline(
>     name = "pipeline",
>     src = "data.json",
> )
> ```
> 
> Con un solo comando:
> ```bash
> bazel build //:pipeline
> ```
> lograremos obtener tanto el CSV (generado por la primera regla) como el archivo comprimido (salida del segundo paso). La macro nos permite orquestar varios targets en una sola invocación.”

### 8. Conclusiones (1:30 - 1:40)

> **Instructor**:  
> “Hemos recorrido desde ejemplos sencillos con `genrule` hasta la creación de reglas personalizadas en Starlark, finalizando con una macro que encadena varios pasos.  
> - `genrule` nos permite realizar acciones puntuales de manera rápida.  
> - Con Starlark, definimos reglas a la medida, controlando inputs y outputs de forma clara.  
> - Las macros nos sirven para agrupar múltiples pasos en un flujo de trabajo.  
> 
> Todo esto ayuda a mantener builds reproducibles y escalables con Bazel.”

### 9. Preguntas y Cierre (1:40 - 2:00)

> **Instructor**:  
> “Ahora, abrimos el espacio para sus dudas o comentarios.  
> 
> Recuerden que la [documentación oficial de Bazel](https://docs.bazel.build) es muy completa y existen repositorios de ejemplos en GitHub que les pueden servir de referencia.  
> 
> ¡Muchas gracias por asistir! Esperamos que este workshop les sea útil para aplicar Bazel en sus proyectos.”

---

## Resumen Final

Con este guion, el instructor puede guiar al grupo de participantes a través de los principales hitos del workshop, cubriendo:

- **Fundamentos de Bazel**  
- **Ejemplo de `genrule` para imprimir contenido**  
- **Procesar un JSON a CSV usando scripts externos**  
- **Crear reglas personalizadas en Starlark**  
- **Encadenar múltiples reglas con macros**

La sesión concluye con un breve repaso y un espacio de preguntas para reforzar los conocimientos adquiridos. ¡Éxito con el workshop!