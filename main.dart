import 'dart:html';
import 'dart:collection';

double perHourPrice = 15.0;

//probably should be a struct. Meh.
class StartAndStop
{
  DateTime startDateTime;
  DateTime endDateTime;
  String toString()
  {
    return "start:" + startDateTime.toString() + " end:" + endDateTime.toString();
  }
}

LinkedHashMap dictOfNamesAndTimes = new LinkedHashMap<String,StartAndStop>();

/* some code that worked for reference --
 * List<TableCellElement> rowcells = row.cells;
      String nameInCell = rowcells[0].text;
      String clockInTime = rowcells[1].text;
      print("nameInCell: ${nameInCell} and clockInTime: ${clockInTime}");
      if(nameToClock == nameInCell)
      {
        print("IT IS ALREADY THERE! DELETE IT!");
      }
      else
      {
        print("not there, add it");
      }
      */



void doClockingWithName()
{
  InputElement tmpel = querySelector('#nameInputField');
  String nameToClock = tmpel.value; 
    
  // add or remove from dict
  
  //it's there, need to stop timing
  if (dictOfNamesAndTimes.containsKey(nameToClock))
  { 
    StartAndStop tmpstartAndStop = dictOfNamesAndTimes[nameToClock];
    if (tmpstartAndStop.endDateTime == null) // don't change an already-existing stop time
    {
      tmpstartAndStop.endDateTime = new DateTime.now();
      // since tmpstartAndStop is passed by reference, it's changed in the global dict
    }
  }
  else //if the name isn't in the dict, need to add
  {
    StartAndStop tmpstartAndStop = new StartAndStop();
    tmpstartAndStop.startDateTime = new DateTime.now();
    dictOfNamesAndTimes[nameToClock] = tmpstartAndStop;
  }
  
  print(dictOfNamesAndTimes);
  
  //now regenerate html table

  TableElement table = querySelector('#namesAndClockInTimesTable');
  
  //kill all the rows except the first (header row)
  while(table.rows.length>1)
    table.rows[1].remove();
 
  //Then loop through dictOfNamesAndTimes to create rows.
  void tmpFuncToRecreateTable(key, value)
  {
    
    // Insert a row at index -1 (the end), and assign that row to a variable.
  TableRowElement row = table.insertRow(-1);
    // Insert a cell at index 0, and assign that cell to a variable.
  TableCellElement cell = row.insertCell(0);
  cell.text = key;
    // Insert more cells with Message Cascading approach and style them.
  row.insertCell(1)
    ..text = value.toString();
  }
  dictOfNamesAndTimes.forEach(tmpFuncToRecreateTable);
  
  
  // ---testing the per-hour thing --- 
  double tmpForDemo = perHourPrice / dictOfNamesAndTimes.keys.length;
  querySelector("#testing").text= tmpForDemo.toString();
  // here's the general gist of it ... but 
  // need to store it for each person what time each person started and accumulate appropriately.
  // Also when people clock out, stop including them.
}

void setUpButtons()
{
  var elem = querySelector('#doClocking');
  //elem.text = "testing";
  
  // this is essentially "when clicked".
  // source: https://webdev.dartlang.org/articles/low-level-html/improving-the-dom
  elem.onClick.listen(
    (event) => doClockingWithName());
}

void main() {
  setUpButtons();
}
