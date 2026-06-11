# moodle-docker

Despliegue local de Moodle con Docker Compose.

## Componentes

- **Moodle 5.x** — imagen oficial `moodlehq/moodle-php-apache:8.4`
- **MariaDB 11** — base de datos
- **HTTPS Portal** — proxy SSL para desarrollo local

## Uso

```bash
docker compose up -d
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

| Volumen          | Contenido            |
|------------------|----------------------|
| `moodle`         | Código de Moodle     |
| `moodledata`     | Datos subidos        |
| `mariadb`        | Base de datos        |

## Notas

- El archivo grande se permite hasta 16 GB (`post_max_size` / `upload_max_filesize`).
- HTTPS Portal se ejecuta en modo local (`STAGE: local`) con certificados autofirmados.
