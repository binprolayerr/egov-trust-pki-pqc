# Tuần 1 — Kiến trúc tin cậy

## 1. Phạm vi và giả định

Nguyên mẫu này mô hình hóa môi trường ký số văn bản hành chính công. Đây không phải là một cổng thông tin hoàn chỉnh và không xác lập giá trị pháp lý. Chỉ cho phép sử dụng các danh tính giả lập, tài liệu mẫu và thông tin xác thực thử nghiệm.

Tuần 1 thiết lập nền tảng tin cậy. IdP, luồng công việc (workflow), ủy quyền/phân quyền (authorization/delegation), ý định ký (signing intent) và ký từ xa đầu-cuối (end-to-end remote signing) là công việc của Tuần 2; chúng được thể hiện dưới dạng các thành phần tương lai, chưa được tính là đã triển khai.

## 2. Các tác nhân

| Tác nhân | Nhu cầu / Giả định tin cậy | Hành động liên quan đến bảo mật |
|---|---|---|
| Công dân / người nộp hồ sơ | Nguồn đầu vào không đáng tin cậy | Nộp hồ sơ và tài liệu giả lập |
| Cán bộ xử lý | Đã được xác thực nhưng không tự động có quyền ký | Xem xét/cập nhật trạng thái hồ sơ |
| Người ký được ủy quyền | Chỉ được ký trong phạm vi vai trò, ủy quyền và luồng công việc | Phê duyệt phiên bản tài liệu được ràng buộc tường minh |
| Vận hành viên Cơ quan Đăng ký (RA) | Xác minh bằng chứng đăng ký theo quy trình cục bộ | Phê duyệt/từ chối yêu cầu cấp chứng chỉ |
| Vận hành viên / dịch vụ CA | Độ tin cậy cao; khóa bí mật của CA phải được bảo vệ | Cấp phát, gia hạn, thu hồi chứng chỉ |
| Dịch vụ TSA | Chỉ đáng tin cậy cho các xác nhận dấu thời gian theo chính sách của nó | Đóng dấu thời gian lên mã băm thông điệp (message imprint) |
| Trình xác minh / vận hành lưu trữ | Phải bảo toàn bằng chứng và các phiên bản chính sách | Xác thực và lưu giữ bằng chứng |
| Lập trình viên / vận hành lab | Kiểm soát môi trường thử nghiệm | Chạy các script; tuyệt đối không dùng bí mật thực tế (production) |

## 3. Các thành phần logic

~~~mermaid
flowchart LR
  C[Công dân / Cán bộ / Người ký] -->|TLS / yêu cầu giả lập| P[Cổng thông tin]
  P --> I[IdP — Tuần 2]
  P --> W[Công cụ luồng công việc — Tuần 2]
  P --> D[Ủy quyền / Phân quyền — Tuần 2]
  P --> H[Băm & Chuẩn hóa — Tuần 2]
  P --> O[Bộ điều phối ký — Tuần 2]
  O -->|Ranh giới PKCS#11 — Tuần 2| S[Token SoftHSM2]
  R[Đăng ký RA] --> CA[CA thử nghiệm]
  CA -->|Chuỗi X.509| V[Trình xác minh]
  CA --> OC[OCSP / CRL]
  T[TSA] -->|Token RFC 3161| V
  S --> O
  O --> V
  V --> A[Kho lưu trữ bằng chứng — tuần sau]
  V --> L[Nhật ký kiểm toán chỉ-ghi-thêm — tuần sau]
~~~

Sơ đồ trên là kiến trúc mục tiêu, không khẳng định rằng mọi mô-đun đều đã tồn tại trong Tuần 1. Tuần 1 triển khai CA thử nghiệm cục bộ, bộ phản hồi OCSP, TSA và token SoftHSM tùy chọn.

## 4. Ranh giới tin cậy

| ID | Ranh giới | Mối đe dọa đi qua | Biện pháp kiểm soát bắt buộc |
|---|---|---|---|
| TB-1 | Tác nhân bên ngoài → Cổng thông tin | Đầu vào sai định dạng, đánh cắp phiên, tấn công phát lại (replay) | Xác thực đầu vào, TLS, xác thực danh tính, kiểm tra tính mới (Tuần 2) |
| TB-2 | Cổng thông tin → IdP / PDP / luồng công việc | Nhầm lẫn quyền hạn (confused deputy), xác nhận cũ, vượt qua chính sách | Tách biệt AuthN/AuthZ, kiểm tra đối tượng/nhà phát hành, ghi nhật ký quyết định chính sách |
| TB-3 | Bộ điều phối → Token PKCS#11 | Trích xuất khóa, ký trái phép, lạm dụng cơ chế | Khóa không thể xuất (non-exportable) nếu được hỗ trợ, mã PIN token, danh sách cơ chế cho phép, đặc quyền tối thiểu |
| TB-4 | RA → Cấp phát CA | Giả mạo danh tính, cấp phát trái phép | Bằng chứng phê duyệt của RA, hồ sơ cấu hình giới hạn, kiểm toán cấp phát, tách biệt ngoại tuyến/root trong môi trường thực tế |
| TB-5 | CA / OCSP / TSA → Trình xác minh | Giả mạo bằng chứng trạng thái/thời gian, phản hồi cũ | Xác thực chuỗi, xác thực chữ ký, chính sách nonce/tính mới, chứng chỉ/bộ phản hồi đáng tin cậy |
| TB-6 | Trình xác minh → Lưu trữ/kiểm toán | Sửa đổi hoặc xóa bằng chứng | Bảo vệ tính toàn vẹn, kiểm soát truy cập, lưu giữ, các mã băm có thể xác minh độc lập |
| TB-7 | Máy chủ lab → Kho lưu trữ mã nguồn | Vô tình công khai thông tin bí mật | `.gitignore`, thư mục `build/` tự động sinh, không dữ liệu thật, quét rò rỉ bí mật |

## 5. Luồng dữ liệu (Tuần 1)

1. Vận hành viên lab khởi tạo cơ sở dữ liệu CA thử nghiệm độc lập và khóa CA chỉ dùng cho thử nghiệm.
2. Khóa người ký giả lập và CSR được tạo cục bộ.
3. CA cấp chứng chỉ người ký thử nghiệm ngắn hạn sau bước phê duyệt cục bộ của script. Đây là bước mô phỏng phê duyệt RA trong phòng lab, không phải xác minh danh tính thật.
4. Trình xác minh xác thực chuỗi chứng chỉ người ký dựa trên CA thử nghiệm.
5. Bộ phản hồi OCSP ký xác nhận trạng thái cho chứng chỉ vừa cấp; máy khách kiểm tra phản hồi đã ký này.
6. TSA ký dấu thời gian RFC 3161 lên mã băm thông điệp (message imprint) của chữ ký CMS.
7. Các script kiểm thử xác minh các tạo phẩm và báo cáo đạt/không đạt. Các khóa bí mật vẫn nằm trong thư mục `build/` đã được Git bỏ qua.

## 6. Các bất biến bảo mật

- Xác thực thành công không đồng nghĩa với việc được ủy quyền ký.
- Sở hữu khóa ký không đồng nghĩa với việc có thẩm quyền ký.
- Một chữ ký hợp lệ về mặt toán học không xác lập giá trị hành chính hay pháp lý.
- Mọi thao tác ký trong tương lai phải ràng buộc người ký, vai trò/ủy quyền, hồ sơ, phiên bản/mã băm tài liệu, trạng thái luồng công việc, nonce và thời hạn hiệu lực.
- Bằng chứng thu hồi và dấu thời gian phải được lưu giữ cùng với chính sách/phiên bản cần thiết để diễn giải chúng về sau.
- Việc lựa chọn thuật toán tuân theo danh sách cho phép (allow-list) và được quản lý phiên bản; không tự động hạ cấp thuật toán (no silent downgrade).
- Không sử dụng bất kỳ danh tính, dữ liệu hay khóa thực tế (production) nào trong phòng lab này.