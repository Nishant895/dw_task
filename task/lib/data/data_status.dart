class DataStatus<T> {
  Status status;
  T? data;
  String? message;

  DataStatus.initial(this.message) : status = Status.INITIAL;

  DataStatus.loading(this.message) : status = Status.LOADING;

  DataStatus.completed(this.message) : status = Status.COMPLETED;

  DataStatus.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message ";
  }
}

enum Status { INITIAL, LOADING, COMPLETED, ERROR }
