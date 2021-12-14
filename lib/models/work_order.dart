class WorkOrder {
  String workOrderId;
  String problemType;
  String supportVisitType;
  String supportVisitText;
  String status;
  String workerName;
  String eta;
  String arrivalTime;
  String departureTime;
  String companyTime;
  String timeOnSite;
  String totalTravelTime;
  String charge;
  String activitiesDescription;
  String code;
  String time;
  String sWHWupdates;
  String sWHWupdateDescription;
  String isWorking;
  String remarkNextVisit;
  String sparepart;
  String clientName;
  String productName;
  String serialNumber;
  String orderType;
  String invoiceId;
  String totalAmount;

  WorkOrder(
      {this.workOrderId,
      this.problemType,
      this.supportVisitType,
      this.supportVisitText,
      this.status,
      this.workerName,
      this.eta,
      this.arrivalTime,
      this.departureTime,
      this.companyTime,
      this.timeOnSite,
      this.totalTravelTime,
      this.charge,
      this.activitiesDescription,
      this.code,
      this.time,
      this.sWHWupdates,
      this.sWHWupdateDescription,
      this.isWorking,
      this.remarkNextVisit,
      this.sparepart,
      this.clientName,
      this.productName,
      this.serialNumber,
      this.orderType,
      this.invoiceId,
      this.totalAmount});
}
