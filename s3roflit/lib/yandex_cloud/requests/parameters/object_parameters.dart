// ignore_for_file: constant_identifier_names

final class ObjectGetParameters {
  /// Sets the `Content-Type` response header.
  final bool responseContentType;

  /// Sets the `Content-Language` response header.
  final bool responseContentLanguage;

  /// Sets the `Expires` response header.
  final bool responseExpires;

  /// Sets the `Cache-Control` response header.
  final bool responseCacheControl;

  /// Sets the `Content-Disposition` response header.
  final bool responseContentDisposition;

  /// Sets the `Content-Encoding` response header.
  final bool responseContentEncoding;

  /// A reference to a specific version of an object.
  final String? versionId;

  const ObjectGetParameters({
    this.responseContentType = false,
    this.responseContentLanguage = false,
    this.responseExpires = false,
    this.responseCacheControl = false,
    this.responseContentDisposition = false,
    this.responseContentEncoding = false,
    this.versionId,
  });

  const ObjectGetParameters.empty()
      : responseContentType = false,
        responseContentLanguage = false,
        responseExpires = false,
        responseCacheControl = false,
        responseContentDisposition = false,
        responseContentEncoding = false,
        versionId = null;

  String get _responseContentType => (responseContentType) ? '&response-content-type=true' : '';

  String get _responseContentLanguage =>
      (responseContentLanguage) ? '&response-content-language=true' : '';

  String get _responseExpires => (responseExpires) ? '&response-expires=true' : '';

  String get _responseCacheControl => (responseCacheControl) ? '&response-cache-control=true' : '';

  String get _responseContentDisposition =>
      (responseContentDisposition) ? '&response-content-disposition=true' : '';

  String get _responseContentEncoding =>
      (responseContentEncoding) ? '&response-content-encoding=true' : '';

  String get _versionId => (versionId?.isNotEmpty == true) ? '&versionId=$versionId' : '';

  String get url =>
      '$_responseContentType$_responseContentLanguage$_responseExpires$_responseCacheControl$_responseContentDisposition$_responseContentEncoding$_versionId';
}

final class ObjectUploadHadersParameters {
  const ObjectUploadHadersParameters({required this.contentMD5, this.xAmzStorageClass});

  /// Cooler classes are intended for long-term storage of objects that are planned
  /// to be workedwith less frequently. The colder the storage, the cheaper it is to
  /// store data in it, but the more expensive it is to read and write it.
  /// If the header is not specified, then the object is saved in the
  /// storage set in the bucket settings.
  final ClassOfStorage? xAmzStorageClass;

  /// Object Storage will calculate the MD5 for the stored object and if the calculated MD5
  /// does not match the one passed in the header, it will return an error.
  final String contentMD5;

  Map<String, String> get _xAmzStorageClass =>
      (xAmzStorageClass != null) ? {'X-Amz-Storage-Class': xAmzStorageClass.toString()} : {};

  Map<String, String> get _contentMD5 => {'Content-MD5': contentMD5};

  Map<String, String> get getHeaders => {..._xAmzStorageClass, ..._contentMD5};
}

enum ClassOfStorage {
  STANDARD,
  COLD,
  ICE,
}
