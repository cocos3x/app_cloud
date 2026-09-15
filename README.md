# App Cloud

Bản **OTA** đầy đủ (WebView và mọi màn hình / chức năng khác).

`playbox_app` không chứa các màn này. Harbor `is_active == true` thì store tải file patch trên Git:

`patches/app_cloud.fcppatch`

Sửa bất kỳ màn nào trong `lib/`, build patch, push file đó. 10 app store nhận cùng một bản.
