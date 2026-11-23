# Tuần 1 — Mô hình mối đe dọa

## Phương pháp

Sử dụng đánh giá STRIDE tinh gọn trên các ranh giới tin cậy trong tài liệu `architecture.md`. Khả năng xảy ra và mức độ tác động mang tính định tính và cần được xem xét lại sau khi triển khai và kiểm thử.

| ID | Mối đe dọa / STRIDE | Tài sản | Ví dụ | Biện pháp kiểm soát / bằng chứng Tuần 1 | Rủi ro tồn dư / bước tiếp theo |
|---|---|---|---|---|---|
| T-01 | Giả mạo danh tính (Spoofing) | Danh tính RA/CA | Kẻ tấn công gửi một CSR mạo danh người ký | Chỉ dùng danh tính giả lập; hồ sơ (profile) CA giới hạn các trường mở rộng | Đăng ký định danh thật và MFA cho vận hành viên nằm ngoài phạm vi |
| T-02 | Giả mạo dữ liệu (Tampering) | Chứng chỉ / cấu hình | Thay đổi trái phép trường mở rộng hoặc thời hạn hiệu lực | CA ký chứng chỉ cấp phát; kiểm tra chuỗi/hồ sơ cấu hình | Bổ sung kiểm tra cú pháp hồ sơ (profile linting) và rà soát cấu hình |
| T-03 | Chối bỏ trách nhiệm (Repudiation) | Hành động cấp phát và trạng thái | Vận hành viên phủ nhận việc đã cấp/thu hồi chứng chỉ | Cơ sở dữ liệu CA cục bộ và nhật ký (log) | Nhật ký chưa có khả năng chống sửa đổi; sau này cần bổ sung nhật ký kiểm toán chỉ-ghi-thêm (append-only) |
| T-04 | Tiết lộ thông tin (Information disclosure) | Khóa bí mật của CA, TSA, người ký | Khóa vô tình bị commit hoặc sao chép | Thư mục `build/` bị bỏ qua; phân quyền cục bộ; danh mục kiểm kê | Vẫn có nguy cơ máy chủ bị xâm nhập; môi trường thực tế cần lưu giữ ngoại tuyến/HSM |
| T-05 | Từ chối dịch vụ (Denial of service) | Các dịch vụ OCSP/TSA/CA | Tấn công làm ngập yêu cầu hoặc cạn kiệt dung lượng ổ đĩa | Dịch vụ chỉ chạy cục bộ và giới hạn số lượng yêu cầu kiểm thử | Chưa có giới hạn tốc độ (rate limit) / tính sẵn sàng cao (HA) thực tế trong Tuần 1 |
| T-06 | Leo thang đặc quyền (Elevation of privilege) | Thẩm quyền cấp phát của CA | CSR chưa được phê duyệt nhưng vẫn nhận được chứng chỉ ký | Bước phê duyệt cục bộ tường minh; giới hạn hồ sơ trong phòng lab | RA đang được mô phỏng; chưa có luồng phê duyệt độc lập |
| T-07 | Trích xuất khóa (Key extraction) | Khóa ký | Ứng dụng đọc được khóa bí mật từ token | Bài thực hành SoftHSM tùy chọn; ghi nhận giới hạn khả năng xuất khóa | SoftHSM hoạt động dựa trên phần mềm, không phải HSM vật lý |
| T-08 | Giả mạo trạng thái / trạng thái cũ | Bằng chứng OCSP | Phản hồi giả mạo hoặc phát lại khẳng định chứng chỉ ở trạng thái `good` | Phản hồi OCSP có chữ ký và xác minh từ phía máy khách | Chính sách nonce/tính mới và bằng chứng lưu trữ cần kiểm thử ở giai đoạn sau |
| T-09 | Sai lệch thời gian | Mã thông báo (token) TSA | Dấu thời gian giả mạo khẳng định việc ký diễn ra sớm hơn | Phản hồi RFC 3161 được ký bởi TSA thử nghiệm; xác minh token | Khóa TSA thử nghiệm chưa được tin cậy độc lập |
| T-10 | Tấn công phát lại (Replay) | Ý định ký trong tương lai | Tái sử dụng yêu cầu ủy quyền cũ | Ghi nhận là yêu cầu cho Tuần 2: nonce, thời hạn hiệu lực, tiêu thụ một lần | Chưa triển khai trong Tuần 1 |
| T-11 | Ký trái phép | Luồng công việc / vai trò | Tài khoản hợp lệ ký sai hồ sơ hoặc sai trạng thái | Được hoãn tường minh sang các bài kiểm thử AuthZ ở Tuần 2 | Không khẳng định Tuần 1 đã chặn được việc ký sai ở cấp độ nghiệp vụ |
| T-12 | Hạ cấp thuật toán (Downgrade) | Chính sách thuật toán | Trình xác minh âm thầm chấp nhận thuật toán yếu hơn | Ánh xạ tiêu chuẩn yêu cầu danh sách cho phép (allow-list) có quản lý phiên bản | Triển khai và kiểm thử phủ định (negative-test) trong các tuần sau |
| T-13 | Sửa đổi kho lưu trữ | Bằng chứng xác thực dài hạn (LTV) | Thay thế tài liệu hoặc xóa bằng chứng thu hồi | Đã lên bố cục lưu trữ bằng chứng; mới chỉ có tạo phẩm cục bộ | Bổ sung lưu trữ chống ghi đè (WORM/object lock) và kiểm tra tính toàn vẹn độc lập sau |

