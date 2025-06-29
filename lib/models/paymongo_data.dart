import 'dart:convert';

class PaymongoData {
  Data? data;

  PaymongoData({
    this.data,
  });

  factory PaymongoData.fromRawJson(String str) => PaymongoData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymongoData.fromJson(Map<String, dynamic> json) => PaymongoData(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? type;
  DataAttributes? attributes;

  Data({
    this.id,
    this.type,
    this.attributes,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        type: json["type"],
        attributes: json["attributes"] == null ? null : DataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "attributes": attributes?.toJson(),
      };
}

class DataAttributes {
  Billing? billing;
  String? billingInformationFieldsEditable;
  dynamic cancelUrl;
  String? checkoutUrl;
  String? clientKey;
  dynamic customerEmail;
  dynamic description;
  List<LineItem>? lineItems;
  bool? livemode;
  String? merchant;
  List<dynamic>? payments;
  PaymentIntent? paymentIntent;
  List<String>? paymentMethodTypes;
  dynamic referenceNumber;
  bool? sendEmailReceipt;
  bool? showDescription;
  bool? showLineItems;
  String? status;
  dynamic successUrl;
  int? createdAt;
  int? updatedAt;
  dynamic metadata;

  DataAttributes({
    this.billing,
    this.billingInformationFieldsEditable,
    this.cancelUrl,
    this.checkoutUrl,
    this.clientKey,
    this.customerEmail,
    this.description,
    this.lineItems,
    this.livemode,
    this.merchant,
    this.payments,
    this.paymentIntent,
    this.paymentMethodTypes,
    this.referenceNumber,
    this.sendEmailReceipt,
    this.showDescription,
    this.showLineItems,
    this.status,
    this.successUrl,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory DataAttributes.fromRawJson(String str) => DataAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        billing: json["billing"] == null ? null : Billing.fromJson(json["billing"]),
        billingInformationFieldsEditable: json["billing_information_fields_editable"],
        cancelUrl: json["cancel_url"],
        checkoutUrl: json["checkout_url"],
        clientKey: json["client_key"],
        customerEmail: json["customer_email"],
        description: json["description"],
        lineItems: json["line_items"] == null ? [] : List<LineItem>.from(json["line_items"]!.map((x) => LineItem.fromJson(x))),
        livemode: json["livemode"],
        merchant: json["merchant"],
        payments: json["payments"] == null ? [] : List<dynamic>.from(json["payments"]!.map((x) => x)),
        paymentIntent: json["payment_intent"] == null ? null : PaymentIntent.fromJson(json["payment_intent"]),
        paymentMethodTypes: json["payment_method_types"] == null ? [] : List<String>.from(json["payment_method_types"]!.map((x) => x)),
        referenceNumber: json["reference_number"],
        sendEmailReceipt: json["send_email_receipt"],
        showDescription: json["show_description"],
        showLineItems: json["show_line_items"],
        status: json["status"],
        successUrl: json["success_url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        metadata: json["metadata"],
      );

  Map<String, dynamic> toJson() => {
        "billing": billing?.toJson(),
        "billing_information_fields_editable": billingInformationFieldsEditable,
        "cancel_url": cancelUrl,
        "checkout_url": checkoutUrl,
        "client_key": clientKey,
        "customer_email": customerEmail,
        "description": description,
        "line_items": lineItems == null ? [] : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "livemode": livemode,
        "merchant": merchant,
        "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x)),
        "payment_intent": paymentIntent?.toJson(),
        "payment_method_types": paymentMethodTypes == null ? [] : List<dynamic>.from(paymentMethodTypes!.map((x) => x)),
        "reference_number": referenceNumber,
        "send_email_receipt": sendEmailReceipt,
        "show_description": showDescription,
        "show_line_items": showLineItems,
        "status": status,
        "success_url": successUrl,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "metadata": metadata,
      };
}

class Billing {
  Address? address;
  dynamic email;
  dynamic name;
  dynamic phone;

  Billing({
    this.address,
    this.email,
    this.name,
    this.phone,
  });

  factory Billing.fromRawJson(String str) => Billing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
        "email": email,
        "name": name,
        "phone": phone,
      };
}

class Address {
  dynamic city;
  dynamic country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

class LineItem {
  int? amount;
  String? currency;
  dynamic description;
  List<dynamic>? images;
  String? name;
  int? quantity;

  LineItem({
    this.amount,
    this.currency,
    this.description,
    this.images,
    this.name,
    this.quantity,
  });

  factory LineItem.fromRawJson(String str) => LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        amount: json["amount"],
        currency: json["currency"],
        description: json["description"],
        images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
        name: json["name"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
        "description": description,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "name": name,
        "quantity": quantity,
      };
}

class PaymentIntent {
  String? id;
  String? type;
  PaymentIntentAttributes? attributes;

  PaymentIntent({
    this.id,
    this.type,
    this.attributes,
  });

  factory PaymentIntent.fromRawJson(String str) => PaymentIntent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentIntent.fromJson(Map<String, dynamic> json) => PaymentIntent(
        id: json["id"],
        type: json["type"],
        attributes: json["attributes"] == null ? null : PaymentIntentAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "attributes": attributes?.toJson(),
      };
}

class PaymentIntentAttributes {
  int? amount;
  String? captureType;
  String? clientKey;
  String? currency;
  dynamic description;
  bool? livemode;
  int? originalAmount;
  String? statementDescriptor;
  String? status;
  dynamic lastPaymentError;
  List<String>? paymentMethodAllowed;
  List<dynamic>? payments;
  dynamic nextAction;
  dynamic paymentMethodOptions;
  dynamic metadata;
  dynamic setupFutureUsage;
  int? createdAt;
  int? updatedAt;

  PaymentIntentAttributes({
    this.amount,
    this.captureType,
    this.clientKey,
    this.currency,
    this.description,
    this.livemode,
    this.originalAmount,
    this.statementDescriptor,
    this.status,
    this.lastPaymentError,
    this.paymentMethodAllowed,
    this.payments,
    this.nextAction,
    this.paymentMethodOptions,
    this.metadata,
    this.setupFutureUsage,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentIntentAttributes.fromRawJson(String str) => PaymentIntentAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentIntentAttributes.fromJson(Map<String, dynamic> json) => PaymentIntentAttributes(
        amount: json["amount"],
        captureType: json["capture_type"],
        clientKey: json["client_key"],
        currency: json["currency"],
        description: json["description"],
        livemode: json["livemode"],
        originalAmount: json["original_amount"],
        statementDescriptor: json["statement_descriptor"],
        status: json["status"],
        lastPaymentError: json["last_payment_error"],
        paymentMethodAllowed: json["payment_method_allowed"] == null ? [] : List<String>.from(json["payment_method_allowed"]!.map((x) => x)),
        payments: json["payments"] == null ? [] : List<dynamic>.from(json["payments"]!.map((x) => x)),
        nextAction: json["next_action"],
        paymentMethodOptions: json["payment_method_options"],
        metadata: json["metadata"],
        setupFutureUsage: json["setup_future_usage"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "capture_type": captureType,
        "client_key": clientKey,
        "currency": currency,
        "description": description,
        "livemode": livemode,
        "original_amount": originalAmount,
        "statement_descriptor": statementDescriptor,
        "status": status,
        "last_payment_error": lastPaymentError,
        "payment_method_allowed": paymentMethodAllowed == null ? [] : List<dynamic>.from(paymentMethodAllowed!.map((x) => x)),
        "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x)),
        "next_action": nextAction,
        "payment_method_options": paymentMethodOptions,
        "metadata": metadata,
        "setup_future_usage": setupFutureUsage,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
