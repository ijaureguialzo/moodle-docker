# moodle-docker

Despliegue local de Moodle con Docker Compose.

## Componentes

- **Moodle 5.x** — imagen oficial `moodlehq/moodle-php-apache:8.4` + código montado desde host
- **MariaDB 11** — base de datos
- **HTTPS Portal** — proxy SSL para desarrollo local

## Primeros pasos: descargar Moodle

Descarga el código de Moodle en el directorio `../moodle` (un nivel arriba de este proyecto):

```bash
cd /Users/widemos/proyectos
curl -L https://download.moodle.org/download.php/stable502/moodle-latest-502.tgz -o moodle.tgz
tar xzf moodle.tgz
mv moodle ../moodle-docker/../moodle
rm moodle.tgz
```

> **Nota:** Si el CDN bloquea la descarga, usa Git como alternativa:
> ```bash
> git clone --depth 1 --branch MOODLE_502_STABLE https://github.com/moodle/moodle.git ../moodle
> ```

## Uso

```bash
make start
```

Acceder a `https://moodle.test` en el navegador.

## Credenciales por defecto

- Usuario: `admin`
- Contraseña: la que se configure en la instalación web

Base de datos:

| Campo        | Valor              |
|--------------|--------------------|
| Host         | mariadb            |
| Puerto       | 3306               |
| Usuario DB   | moodle             |
| Contraseña DB| 12345Abcde         |

## Volúmenes

| Volumen            | Contenido            |
|--------------------|----------------------|
| `../moodle`        | Código de Moodle     |
| `moodledata`       | Datos subidos        |
| `mariadb`          | Base de datos        |

## Notas

- El archivo grande se permite hasta 16 GB (`post_max_size` / `upload_max_filesize`).
- HTTPS Portal se ejecuta en modo local (`STAGE: local`) con certificados autofirmados.
- Para actualizar Moodle, descarga la versión más reciente y reemplaza el directorio `../moodle`.
