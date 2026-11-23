# Tuần 1 — Ánh xạ tiêu chuẩn

Bảng ánh xạ này xác định các tiêu chuẩn liên quan. 

| Tài liệu tham chiếu | Mức độ liên quan | Xử lý trong Tuần 1 |
|---|---|---|
| X.509 / RFC 5280 | Hồ sơ chứng chỉ và đường dẫn chứng thực | Chứng chỉ CA thử nghiệm và người ký; xác thực chuỗi |
| RFC 6960 | Giao thức trạng thái chứng chỉ trực tuyến (OCSP) | Phản hồi `good` đã được ký cho chứng chỉ trong phòng lab |
| RFC 3161 | Giao thức Dấu thời gian (Time-Stamp Protocol) | TSA cấp phát mã thông báo (token); máy khách xác minh token |
| RFC 5652 (CMS) | Cú pháp Thông điệp Mật mã (Cryptographic Message Syntax) | Chữ ký tách rời (detached signature) CMS dùng làm đầu vào cho dấu thời gian |
| RFC 8017 | Đặc tả mật mã RSA | Sử dụng RSA cho các khóa CA/người ký/TSA thử nghiệm cổ điển |
| RFC 8410 | Định danh X.509 cho Ed25519/Ed448 | Phương án thay thế cổ điển gọn nhẹ tiềm năng; không bắt buộc trong các script Tuần 1 |
| FIPS 204 | ML-DSA | Định hướng PQC từ đề xuất; việc triển khai/đo lường hiệu năng (benchmark) hoãn sang Tuần 3 |
| FIPS 205 | SLH-DSA | Định hướng chữ ký dài hạn bổ sung trong tương lai |
| RFC 9881 / RFC 9882 | ML-DSA trong X.509 / CMS (tài liệu tham chiếu của đề xuất) | Theo dõi tính tương thích trong phần việc PQC sau này; không mặc định rằng OpenSSL đã cài đặt hỗ trợ sẵn |
| PKCS#11 | Giao diện token cho các đối tượng/tác vụ mật mã | Bài kiểm tra nhanh (smoke test) SoftHSM2/OpenSC tùy chọn; tích hợp ký từ xa hoãn lại sau |
| Tài liệu OpenSSL | Tham chiếu triển khai phòng lab | Ghi lại chính xác `openssl version -a`; sử dụng các tính năng dòng lệnh sẵn có trên máy |
