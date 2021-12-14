import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/models/applied_job.dart';
import 'package:service_app/models/artist_chat.dart';
import 'package:service_app/models/booking.dart';
import 'package:service_app/models/chart.dart';
import 'package:service_app/models/earings.dart';
import 'package:service_app/models/feedback.dart';
import 'package:service_app/models/job.dart';
import 'package:service_app/models/serialNumber.dart';
import 'package:service_app/models/ticket.dart';
import 'package:service_app/models/ticket_comment.dart';
import 'package:service_app/models/work_order.dart';
import '../models/notification.dart';

//const String base_url = 'https://project.cander.in/flutter_service/webservice';
const String base_url = 'https://swissmed.deumsoft.com/webservice';

class JobProvider with ChangeNotifier {
  List<String> _images = [];

  List<Notifications> _notifications = [];
  List<Job> _artistJobs = [];
  List<AppliedJob> _appliedJobs = [];
  List<ArtistChat> _artistChats = [];
  List<Booking> _acceptedBookings = [];
  List<Booking> _rejectedBookings = [];
  List<Booking> _bindingBookings = [];
  List<Booking> _completedBookings = [];
  List<TicketComment> _ticketComments = [];
  List<Ticket> _tickets = [];
  Earnings _earnings = Earnings();
  Booking _currentBooking = Booking();
  List<WorkOrder> _workOrder = [];
  List<MyFeedBack> _feedback = [];
  List<ChartData> _chart = [];
  List<SerialNumber> _clients = [];
  List<SerialNumber> _serialNumberById = [];

  String _userId;
  set userId(String userIdValue) {
    _userId = userIdValue;
  }

  Booking get currentBooking {
    return _currentBooking;
  }

  List<Ticket> get tickets {
    return [..._tickets];
  }

  List<TicketComment> get ticketComments {
    return [..._ticketComments];
  }

  Earnings get earnings {
    return _earnings;
  }

  List<Booking> get acceptedBookings {
    return [..._acceptedBookings];
  }

  List<Booking> get rejectedBookings {
    return [..._rejectedBookings];
  }

  List<Booking> get bindingBookings {
    return [..._bindingBookings];
  }

  List<Booking> get completedBookings {
    return [..._completedBookings];
  }

  List<AppliedJob> get appliedJobs {
    return [..._appliedJobs];
  }

  List<Job> get artistJobs {
    return [..._artistJobs];
  }

  List<ArtistChat> get artistChats {
    return [..._artistChats];
  }

  List<Notifications> get notifications {
    return [..._notifications];
  }

  List<String> get images {
    return [..._images];
  }

  List<ChartData> get workerdashboardData {
    return [..._chart];
  }

  List<SerialNumber> get getAllClientsDropDown {
    return [..._clients];
  }

  List<SerialNumber> get serialNumbers {
    return [..._serialNumberById];
  }

  Future<String> startJob({
    String userId,
    String jobId,
    String price,
    String date,
    String timezone,
  }) async {
    final url = '$base_url/startJob';
    try {
      final response = await http.post(url, body: {
        'user_id': userId,
        'job_id': jobId,
        'artist_id': _userId,
        'price': price,
        'timezone': timezone,
        'date_string': date,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('start message ${body['message']}');
      if (!body['message'].toString().contains('successfully')) {
        return body['message'];
      }
      await getAppliedJobs();
      await getAllJobs();
      return body['message'];
    } catch (err) {
      print('err message ${err.toString()}');
      return err.toString();
    }
  }

  Future<String> rejectJob({String ajId, String jobId, String status}) async {
    var url = '$base_url/job_status_artist';
    try {
      final response = await http.post(
        url,
        body: {
          'aj_id': ajId,
          'job_id': jobId,
          'status': status,
        },
      );
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('object ${body['message']}');

      await getAppliedJobs();
      return body['message'];
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> applyToJob({
    String userId,
    String jobId,
    String description,
    String price,
  }) async {
    final url = '$base_url/applied_job';
    try {
      final response = await http.post(url, body: {
        'user_id': userId,
        'job_id': jobId,
        'artist_id': _userId,
        'description': description,
        'price': price,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('applied ${body['message']}');
      if (!body['message'].toString().contains('successfully')) {
        return body['message'];
      }
      await getAllJobs();
      return body['message'];
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> getCurrentBookingsArtist() async {
    var url = '$base_url/getMyCurrentBooking';
    try {
      final response = await http.post(url, body: {'artist_id': _userId});
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('${body['message']}');
      if (body['message'] != 'Get my current booking.') {
        _currentBooking = Booking();
        return;
      }
      final booking = Map<String, dynamic>.from(body['data']);
      final newBooking = Booking(
        address: booking['address'],
        bookingDate: booking['booking_date'],
        bookingTime: booking['booking_time'],
        description: booking['description'],
        flag: booking['booking_flag'],
        id: booking['id'],
        userImage: booking['userImage'],
        userName: booking['userName'],
        startTime: booking['start_time'],
      );
      _currentBooking = newBooking;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllBookingsArtist(String flag) async {
    var url = '$base_url/getAllBookingArtist';
    try {
      final response = await http.post(url, body: {
        'artist_id': _userId,
        'booking_flag': flag,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('${body['message']} flag:$flag');
      if (body['message'] != 'Get my current booking.') {
        switch (flag) {
          case '0':
            _bindingBookings = [];
            notifyListeners();
            break;
          case '1':
            _acceptedBookings = [];
            notifyListeners();
            break;
          case '2':
            _rejectedBookings = [];
            notifyListeners();
            break;
          case '4':
            _completedBookings = [];
            notifyListeners();
            break;
        }
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);
      final bookings = data
          .map(
            (booking) => Booking(
              address: booking['address'],
              bookingDate: booking['booking_date'],
              bookingTime: booking['booking_time'],
              description: booking['description'],
              flag: booking['booking_flag'],
              id: booking['id'],
              userImage: booking['userImage'],
              userName: booking['userName'],
            ),
          )
          .toList();
      switch (flag) {
        case '0':
          _bindingBookings = bookings;
          notifyListeners();
          break;
        case '1':
          _acceptedBookings = bookings;
          notifyListeners();
          break;
        case '2':
          _rejectedBookings = bookings;
          notifyListeners();
          break;
        case '4':
          _completedBookings = bookings;
          notifyListeners();
          break;
      }
    } catch (err) {
      throw err;
    }
  }

  Future<bool> bookingOperation(String request, String id) async {
    var url = '$base_url/booking_operation';
    try {
      final response = await http.post(url, body: {
        'user_id': _userId,
        'request': request,
        'booking_id': id,
      });

      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('${body['message']}');
      if (body['message'] == 'Booking accepted successfully.') {
        return true;
      }
      if (body['message'] == 'Booking Started successfully.') {
        return true;
      }
      return false;
    } catch (err) {
      throw err;
    }
  }

  Future<bool> declineOperation(String id) async {
    var url = '$base_url/decline_booking';
    try {
      final response = await http.post(url, body: {
        'user_id': _userId,
        'booking_id': id,
        'decline_by': '1',
        'decline_reason': 'Busy'
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('${body['message']}');
      if (body['message'] == 'Booking Decline successfully.') {
        return true;
      }
      return false;
    } catch (err) {
      throw err;
    }
  }

  Future<void> getArtistEarnings() async {
    var url = '$base_url/myEarning1';
    try {
      final response = await http.post(url, body: {
        'artist_id': _userId,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (body['message'] != 'Get my earning') {
        return;
      }
      final data = Map<String, dynamic>.from(body['data']);
      final earnings = Earnings(
        cashEarning: double.parse(data['cashEarning'].toString()),
        completePercentages:
            double.parse(data['completePercentages'].toString()),
        currencySymbol: data['currency_symbol'],
        jobDone: double.parse(data['jobDone'].toString()),
        onlineEarning: double.parse(data['onlineEarning'].toString()),
        totalEarning: double.parse(data['totalEarning'].toString()),
        totalJob: double.parse(data['totalJob'].toString()),
        walletAmount: data['walletAmount'],
      );
      _earnings = earnings;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<String> walletRequest() async {
    var url = '$base_url/walletRequest';
    try {
      final response = await http.post(url, body: {
        'user_id': _userId,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;

      return body['message'];
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> getChatForArtist() async {
    var url = '$base_url/getChatHistoryForArtist';
    try {
      final response = await http.post(url, body: {
        'artist_id': _userId,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (body['message'] != 'Get chat history.') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['my_chat']);
      final chats = data
          .map(
            (chat) => ArtistChat(
              id: chat['id'],
              message: chat['message'],
              chatType: chat['chat_type'],
              date: chat['date'],
              image: chat['image'],
              sendAt: chat['send_at'],
              sendBy: chat['send_by'],
              senderName: chat['sender_name'],
              userId: chat['user_id'],
              userImage: chat['userImage'],
              userName: chat['userName'],
            ),
          )
          .toList();
      _artistChats = chats;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAppliedJobs() async {
    var url = '$base_url/get_applied_job_artist';
    try {
      final response = await http.post(url, body: {
        'artist_id': _userId,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (body['message'] != 'Applied Jobs Found') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);
      if (data == null) {
        return;
      }
      final jobs = data
          .map(
            (job) => AppliedJob(
                id: job['aj_id'],
                userId: job['user_id'],
                artistId: job['artist_id'],
                jobId: job['job_id'],
                price: job['price'],
                description: job['description'],
                status: job['status'],
                createdAt: job['created_at'],
                updatedAt: job['updated_at'],
                currencySymbol: job['currency_symbol'],
                categoryName: job['category_name'],
                userImage: job['user_image'],
                userName: job['user_name'],
                userAddress: job['user_address'],
                title: job['title'],
                jobDate: job['job_date'],
                time: job['time'],
                jobTimestamp: job['job_timestamp'],
                userMobile: job['user_mobile'],
                userEemail: job['user_email']),
          )
          .toList();
      _appliedJobs = jobs;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllJobs() async {
    var url = '$base_url/get_all_job';
    try {
      final response = await http.post(url, body: {
        'artist_id': _userId,
      });
      final body =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (body['message'] == 'No jobs available.') {
        _artistJobs = [];
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);
      if (data == null) {
        _artistJobs = [];
        return;
      }
      final jobs = data
          .map(
            (job) => Job(
              id: job['id'],
              userId: job['user_id'],
              jobId: job['job_id'],
              address: job['address'],
              appliedJob: job['applied_job'],
              avtar: job['avtar'],
              categoryId: job['category_id'],
              categoryName: job['category_name'],
              categoryPrice: job['category_price'],
              createdAt: job['created_at'],
              currencySymbol: job['currency_symbol'],
              description: job['description'],
              isEdit: job['is_edit'],
              jobDate: job['job_date'],
              jobTimestamp: job['job_timestamp'],
              lati: job['lati'],
              longi: job['longi'],
              price: job['price'],
              status: job['status'],
              time: job['time'],
              title: job['title'],
              updatedAt: job['updated_at'],
            ),
          )
          .toList();
      _artistJobs = jobs;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> fetchSliderImages() async {
    var url = '$base_url/get_sliders';
    try {
      final response = await http.get(url);
      final data = List<Map<String, dynamic>>.from(
          jsonDecode(response.body.toString())['data']);
      if (data == null) {
        return;
      }
      final images = data.map((json) => json['image'].toString()).toList();
      print('images $images');
      _images = images;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getNotifications() async {
    var url = '$base_url/getNotifications';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final data =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (data['message'] != 'Get my notifications.') {
        return;
      }
      final notifications =
          List<Map<String, dynamic>>.from(data['my_notifications']);
      final notificationsList = notifications
          .map(
            (json) => Notifications(
              id: json['id'],
              title: json['title'],
              type: json['type'],
              message: json['msg'],
              date: json['created_at'],
            ),
          )
          .toList();
      _notifications = notificationsList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getTickets() async {
    var url = '$base_url/getMyTicket';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final data =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return;
      }
      print(data);
      final tickets = List<Map<String, dynamic>>.from(data['my_ticket']);
      final ticketsList = tickets
          .map(
            (json) => Ticket(
              id: json['id'],
              reason: json['reason'],
              description: json['description'],
              createdAt: json['craeted_at'],
              status: json['status'],
              userId: json['user_id'],
            ),
          )
          .toList();
      _tickets = ticketsList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addTicket(String title, String description) async {
    var url = '$base_url/generateTicket';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'reason': title,
          'description': description,
        },
      );
      if (response.statusCode != 200) {
        return;
      }
      await getTickets();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getTicketComments(String ticketId) async {
    _ticketComments = [];
    var url = '$base_url/getTicketComments';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'ticket_id': ticketId,
        },
      );
      if (response.statusCode != 200) {
        return;
      }
      final data =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      print('comments: $data');
      final tickets = List<Map<String, dynamic>>.from(data['ticket_comment']);
      final ticketsList = tickets
          .map(
            (json) => TicketComment(
              id: json['id'],
              ticketId: json['ticket_id'],
              comment: json['comment'],
              createdAt: json['created_at'],
              role: json['role'],
              userId: json['user_id'],
              userName: json['userName'],
            ),
          )
          .toList();
      _ticketComments = ticketsList;
      notifyListeners();
    } catch (err) {}
  }

  Future<bool> sendComment(String ticketId, String comment) async {
    var url = '$base_url/addTicketComments';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'ticket_id': ticketId,
          'comment': comment,
        },
      );
      if (response.statusCode != 200) {
        return false;
      }
      await getTicketComments(ticketId);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<List<WorkOrder>> workerListOfWork(String typeid) async {
    final url = '$base_url/WorkerListsWorkOrders';
    try {
      final response = await http.post(
        url,
        body: {
          'typeid': typeid,
          'workerid': _userId,
        },
      );
      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (responseData['message'] != 'WorkOrder List') {
        return null;
      }
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final workOrders = data
          .map((json) => WorkOrder(
              workOrderId: json['WorkOrderID'],
              problemType: json['ProblemType'],
              supportVisitType: json['SupportVisitType'],
              supportVisitText: json['SupportVisitText'],
              status: json['Status'],
              workerName: json['WorkerName'],
              eta: json['ETA'],
              arrivalTime: json['ArrivalTime'],
              departureTime: json['DepartureTime'],
              companyTime: json['CompanyTime'],
              timeOnSite: json['TimeOnSite'],
              totalTravelTime: json['TotalTravelTime'],
              charge: json['Charge'],
              activitiesDescription: json['ActivitiesDescription'],
              code: json['Code'],
              time: json['Time'],
              sWHWupdates: json['SWHWupdates'],
              sWHWupdateDescription: json['SWHWupdateDescription'],
              isWorking: json['isWorking'],
              remarkNextVisit: json['RemarkNextVisit'],
              sparepart: json['sparepart'],
              clientName: json['ClientName'],
              productName: json['product_name'],
              serialNumber: json['SerialNumber'],
              orderType: json['OrderType'],
              invoiceId: json['invoice_id'],
              totalAmount: json['total_amount']))
          .toList();
      _workOrder = workOrders;
      notifyListeners();
      log('res type: ${workOrders.length} ${responseData['data']}');
      return _workOrder;
    } catch (err) {
      throw err;
    }
  }

  Future<bool> workercompleteWo(
      String woid,
      String starttime,
      String endtime,
      String companyTime,
      String timeOnSite,
      String totalTravelTime,
      String charge,
      String activitiesDescription,
      String code,
      String time,
      String sWHWupdates,
      String sWHWupdateDescription,
      String isWorking,
      String remarkNextVisit,
      String sparepart,
      String img) async {
    var url = '$base_url/WorkercompleteWo';
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'woid': woid,
          'starttime': starttime,
          'endtime': endtime,
          'CompanyTime': companyTime,
          'TimeOnSite': timeOnSite,
          'TotalTravelTime': totalTravelTime,
          'Charge': charge,
          'ActivitiesDescription': activitiesDescription,
          'Code': code,
          'Time': time,
          'SWHWupdates': sWHWupdates,
          'SWHWupdateDescription': sWHWupdateDescription,
          'isWorking': isWorking,
          'RemarkNextVisit': remarkNextVisit,
          'sparepart': sparepart,
          'img': img
        },
      );

      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<bool> addClientFeedBack(
      String clientname,
      String address,
      String feedback,
      String pyetje1,
      String pyetje2,
      String pyetje3,
      String pyetje4,
      String pyetje5,
      String pyetje6,
      String pyetje7,
      String pyetje8,
      String pyetje9,
      String pyetje10,
      String pyetje11,
      String img) async {
    var url = '$base_url/addClientFeedBack';
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'clientname': clientname,
          'address': address,
          'feedback': feedback,
          'create_id': _userId,
          'pyetje1': pyetje1,
          'pyetje2': pyetje2,
          'pyetje3': pyetje3,
          'pyetje4': pyetje4,
          'pyetje5': pyetje5,
          'pyetje6': pyetje6,
          'pyetje7': pyetje7,
          'pyetje8': pyetje8,
          'pyetje9': pyetje9,
          'pyetje10': pyetje10,
          'pyetje11': pyetje11,
          'img': img,
        },
      );

      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<List<MyFeedBack>> getClientFeedBackbyid() async {
    final url = '$base_url/GetClientFeedBackbyid';
    try {
      final response = await http.post(
        url,
        body: {
          'create_id': _userId,
        },
      );
      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (responseData['message'] != 'Get All Client Feedbacks') {
        return null;
      }
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final feedback = data
          .map((json) => MyFeedBack(
              clientName: json['clientname'],
              address: json['address'],
              feedback: json['feedback']))
          .toList();
      _feedback = feedback;
      notifyListeners();
      print('res type: ${feedback.length} ${responseData['data']}');
      return feedback;
    } catch (err) {
      throw err;
    }
  }

  Future<bool> woNotComplete(String woid) async {
    final url = '$base_url/WoNotComplete';
    try {
      final response = await http.post(
        url,
        body: {
          'woid': woid,
        },
      );
      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (responseData['message'] !=
          'WorkOrder moved Succesfully to Not Complete') {
        return false;
      } else {
        return true;
      }
      //final data = List<Map<String, dynamic>>.from(responseData['data']);
      // final feedback = data
      //     .map((json) => MyFeedBack(
      //         clientName: json['clientname'],
      //         address: json['address'],
      //         feedback: json['feedback']))
      //     .toList();
      // _feedback = feedback;
    } catch (err) {
      throw err;
    }
  }

  Future<List<ChartData>> workerdashboardChart() async {
    final url = '$base_url/WorkerDashboardChart';
    try {
      final response = await http.post(
        url,
        body: {
          'userid': _userId,
        },
      );
      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (responseData['message'] != 'Dashboard Data') {
        return null;
      }
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final chart = data
          .map(
              (json) => ChartData(status: json['Status'], total: json['Total']))
          .toList();
      _chart = chart;
      notifyListeners();
      print('res type: ${chart.length} ${responseData['data']}');
      return _chart;
    } catch (err) {
      throw err;
    }
  }

  Future<bool> workerShtoTikete(
      String etaTime,
      String serialNumberId,
      String problemtypeId,
      String problemdesc,
      String supportvisittype,
      String supportVisitText) async {
    var url = '$base_url/WorkeraddWorkOrder';
    try {
      final response = await http.post(
        url,
        body: {
          'userid': _userId,
          'ETA': etaTime,
          'ClientOrderID': serialNumberId,
          'ProblemTypeID': problemtypeId,
          'ProblemDesc': problemdesc,
          'SupportVisitType': supportvisittype,
          'SupportVisitText': supportVisitText,
        },
      );
      print(serialNumberId +
          problemtypeId +
          problemdesc +
          supportvisittype +
          supportVisitText);
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllClients() async {
    final url = '$base_url/getAllClientsDropDown';
    try {
      final response = await http.post(
        url,
        body: {
          //  'clientid': _userId,
        },
      );
      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (responseData['message'] != 'Get All Clients DropDown') {
        return null;
      }
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final clients = data
          .map((json) => SerialNumber(id: json['ID'], name: json['name']))
          .toList();
      _clients = clients;
      notifyListeners();

      print('res type: ${clients.length} ${responseData['data']}');
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllProdByIdDropDown(String clientid) async {
    final url = '$base_url/getAllProdDropDown';
    try {
      final response = await http.post(
        url,
        body: {
          'clientid': clientid,
        },
      );
      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      if (responseData['message'] != 'Get All Products DropDown') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final serialNumberById = data
          .map((json) => SerialNumber(id: json['ID'], name: json['name']))
          .toList();
      _serialNumberById = serialNumberById;
      notifyListeners();

      print('res type: ${serialNumberById.length} ${responseData['data']}');
    } catch (err) {
      throw err;
    }
  }
}
