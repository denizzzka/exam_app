int _nextUniqId = 0;

class Record
{
  int uniqId = -2;
  String bookName;
  String authors;

  Record(this.bookName, this.authors);
}

class LibraryCatalog
{
  List<Record> _records;

  LibraryCatalog()
  {
    _records = new List<Record>();
  }

  int addRecord(Record r)
  {
    r.uniqId = _nextUniqId;
    _nextUniqId++;

    _records.add(r);

    return r.uniqId;
  }

  Record getRecordByNum(int recordNum)
  {
    return _records[recordNum];
  }

  int getRecordsNum()
  {
    return _records.length;
  }

  void tryToDelRecordById(int recordId)
  {
    for(var i = 0; i < _records.length; i++)
    {
      if(_records[i].uniqId == recordId)
      {
        _records.removeAt(i);

        break;
      }
    }
  }

  void refreshRecordById(int recordId, Record newRecordData)
  {
    for(var i = 0; i < _records.length; i++)
    {
      if(_records[i].uniqId == recordId)
      {
        newRecordData.uniqId = recordId;
        _records[i] = newRecordData;

        break;
      }
    }
  }
}
