import 'package:flutter/material.dart';
import 'package:gym_app/service/ticket_service.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatefulWidget {
  final String type;
  final Function(List<Map<String, dynamic>>)
      onSelectionChanged; // 선택된 티켓을 부모로 전달하는 콜백

  const TicketCard(
      {super.key, required this.type, required this.onSelectionChanged});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  List<Map<String, dynamic>> tickets = []; // 이용권 리스트
  Map<int, bool> isCheckedMap = {}; // 체크 상태 저장
  bool isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _loadTickets(); // 이용권 불러오기
  }

  // 일반 이용권만 필터링하여 가져오기
  Future<void> _loadTickets() async {
    try {
      TicketService ticketService = TicketService();
      var allTickets = await ticketService.getTicket();

      List<Map<String, dynamic>> filteredTickets =
          List<Map<String, dynamic>>.from(
              allTickets.where((ticket) => ticket['type'] == widget.type));

      setState(() {
        tickets = filteredTickets;
        isCheckedMap = {for (int i = 0; i < tickets.length; i++) i: false};
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      setState(() {
        isLoading = false; // 로딩 실패 시도 완료
      });
    }
  }

  void _updateSelection() {
    List<Map<String, dynamic>> selectedTickets = [];
    for (int i = 0; i < tickets.length; i++) {
      if (isCheckedMap[i] == true) {
        selectedTickets.add(tickets[i]);
      }
    }
    widget.onSelectionChanged(selectedTickets); // 부모로 전달
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 49, 47, 47),
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중
          : tickets.isEmpty
              ? const Center(
                  child: Text(
                    "이용 가능한 이용권이 없습니다.",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    var ticket = tickets[index];

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedMap[index] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  // 모든 항목을 false로 설정한 후, 현재 항목만 true로 설정
                                  for (int i = 0; i < tickets.length; i++) {
                                    isCheckedMap[i] = false;
                                  }
                                  isCheckedMap[index] = value ?? false;
                                  _updateSelection(); // 선택 변경 시 콜백 호출
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket['name'] ?? "이름 없음",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ticket['price'] != null
                                        ? '${NumberFormat('#,###').format(ticket['price'])}원'
                                        : "가격 정보 없음",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.blueAccent),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ticket['info'] ?? "설명 없음",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
