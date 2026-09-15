# App Cloud

Bản **OTA** của PlayBox. Cùng `app_id` Shorebird với `playbox_app`.

- Sửa UI ở đây (`lib/`)
- Đẩy bằng `shorebird patch ios --track=staging` (thử) hoặc `shorebird patch ios` (user thật)
- Máy đang chạy bản `playbox_app` release sẽ nhận bản này sau khi mở lại app

Không đổi `shorebird.yaml` (`app_id` phải giống playbox_app).
