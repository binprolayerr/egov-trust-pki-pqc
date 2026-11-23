# Tuần 1 — Danh mục khóa và thông tin bí mật

Các cấp độ bảo vệ là mức xử lý do dự án tự định nghĩa, không phải là chứng nhận chính thức.

- **H0 — Công khai:** chứng chỉ, khóa công khai, chính sách đã công bố, bằng chứng đã được làm sạch dữ liệu nhạy cảm.
- **H1 — Nội bộ:** cấu hình không bí mật và siêu dữ liệu (metadata) vận hành; có kiểm soát truy cập.
- **H2 — Mật:** khóa bí mật của người ký/TSA/OCSP và mã PIN của token; hạn chế truy cập, lưu trữ được mã hóa/bảo vệ, có luân chuyển khóa (rotation) và kiểm toán.
- **H3 — Khóa gốc/hạt giống tối mật:** khóa bí mật gốc (root) của CA, dữ liệu hạt giống (seed)/bản sao lưu PQC, KEK/DEK; phân tách nghiêm ngặt nhất, lưu giữ ngoại tuyến/HSM, kiểm soát kép (dual control) và kiểm thử khôi phục trong môi trường thực tế (production).

| Bí mật / Đầu vào | Chủ sở hữu | Mục đích | Cấp độ | Lưu trữ Tuần 1 | Vòng đời / Ghi chú |
|---|---|---|---|---|---|
| Khóa bí mật CA thử nghiệm | Vận hành viên lab | Ký các chứng chỉ thử nghiệm và chứng chỉ OCSP/TSA | H3 (chỉ dùng thử nghiệm) | `build/pki/private/ca.key.pem`, quyền 600 | Dùng một lần rồi bỏ; không tái sử dụng; khóa gốc thực tế nên đặt ngoại tuyến |
| Khóa bí mật người ký thử nghiệm | Người ký thử nghiệm / lab | Ký thử nghiệm dựa trên chứng chỉ | H2 | `build/pki/private/signer.key.pem`, quyền 600 | Thu hồi/thay thế khi bị lộ; tuyệt đối không commit |
| Khóa bí mật TSA thử nghiệm | Dịch vụ TSA | Ký các mã thông báo (token) RFC 3161 | H2 | `build/pki/private/tsa.key.pem`, quyền 600 | Khóa chuyên dụng; tuyệt đối không dùng để ký tài liệu |
| Khóa bí mật bộ phản hồi OCSP | Dịch vụ OCSP | Ký các phản hồi OCSP | H2 | `build/pki/private/ocsp.key.pem`, quyền 600 | Chứng chỉ bộ phản hồi chuyên dụng có EKU là OCSPSigning |
| Mã PIN / SO PIN của token SoftHSM | Vận hành viên lab | Mở khóa token / quản trị token | H2 | Chỉ lưu trong biến môi trường/shell cục bộ; không commit | Chỉ là giá trị giữ chỗ trong lab; thực tế cần trình quản lý bí mật/kiểm soát HSM |
| Khóa bí mật / hạt giống PQC tương lai | Dịch vụ ký | Các tác vụ ML-DSA/SLH-DSA | H2/H3 tùy theo cơ chế lưu giữ | Chưa tạo trong Tuần 1 | Ghi nhận nhà cung cấp, khả năng xuất khóa, sao lưu và mức độ phơi nhiễm trước khi dùng |
| KEK / DEK tương lai | Dịch vụ lưu trữ | Bảo vệ bằng chứng / dữ liệu đã lưu | H3 / H2 | Chưa tạo trong Tuần 1 | Định nghĩa mã hóa phong bì (envelope encryption), luân chuyển và khôi phục ở nhánh lưu trữ |
| Chứng chỉ công khai / khóa công khai | CA / các dịch vụ | Xác minh và phân phối sự tin cậy | H0 | `build/pki/certs/` | Công bố kèm nguồn gốc xuất xứ; trạng thái thu hồi được quản lý riêng |
| Cơ sở dữ liệu CA / số sê-ri / số CRL | Vận hành viên CA | Trạng thái cấp phát và thu hồi | H1 (trọng yếu về tính toàn vẹn) | `build/pki/db/` | Sao lưu nhất quán; bảo vệ tính toàn vẹn và tính sẵn sàng |

