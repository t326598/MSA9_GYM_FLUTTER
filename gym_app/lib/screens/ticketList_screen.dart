import 'package:flutter/material.dart';
import 'package:gym_app/service/ticketList_service.dart'; // ticketList_service 임포트
import 'package:provider/provider.dart'; // provider 임포트
import 'package:gym_app/provider/user_provider.dart'; // UserProvider 임포트
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // intl 패키지 임포트

class TicketlistScreen extends StatefulWidget {
  const TicketlistScreen({super.key});

  @override
  State<TicketlistScreen> createState() => _TicketlistScreenState();
}

class _TicketlistScreenState extends State<TicketlistScreen> {
  late Future<Map<String, dynamic>> buyListData;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      int? userNo = Provider.of<UserProvider>(context, listen: false).userNo;
      print("로그인된 사용자 no: $userNo");

      if (userNo != null) {
        buyListData = TicketListService().getBuyList(userNo);
      } else {
        setState(() {
          buyListData = Future.error('로그인 정보가 없습니다.');
        });
      }
    } catch (error) {
      setState(() {
        buyListData = Future.error('사용자 정보 로딩 실패');
      });
    }
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(parsedDate);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 47, 47),
      appBar: AppBar(
        title: const Text('이용권 내역', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: buyListData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('오류 발생: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text('데이터가 없습니다.',
                    style: TextStyle(color: Colors.white)));
          } else {
            var data = snapshot.data!;
            var buyList = data['buyList'] as List<dynamic>;
            var ticketBuyList = data['ticketBuyList'] as List<dynamic>;

            var currentTicket =
                ticketBuyList.isNotEmpty ? ticketBuyList.last : null;
            String ticketName =
                currentTicket != null ? currentTicket['ticketName'] : '없음';
            String purchaseDate = currentTicket != null &&
                    currentTicket['startDate'] != null
                ? formatDate(currentTicket['startDate'])
                : '-';
            String endDate = currentTicket != null &&
                    currentTicket['endDate'] != null
                ? formatDate(currentTicket['endDate'])
                : '-';

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  '보유중인 이용권',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                _buildInfoRow('이용권', ticketName),
                _buildInfoRow('구매일시', purchaseDate),
                _buildInfoRow('만료일시', endDate),

                const SizedBox(height: 30),
                const Text(
                  '이용권 내역',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                if (buyList.isNotEmpty) ...[
                  for (var item in buyList) _buildTicketRow(item),
                ],
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(Map<String, dynamic> item) {
    var ticketName = item['ticketName'] ?? '이용권';
    var startDate = item['startDate'] ?? '-';
    var ticketPrice = item['ticketPrice'] ?? '가격 미제공';

    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(
          ticketName,
          style: GoogleFonts.notoSansKr(
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        subtitle: Text(
          '구매일: ${formatDate(startDate)}',
          style: GoogleFonts.notoSansKr(
              textStyle: const TextStyle(fontSize: 16, color: Colors.white70)),
        ),
        trailing: Text(
          '$ticketPrice 원',
          style: GoogleFonts.notoSansKr(
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
