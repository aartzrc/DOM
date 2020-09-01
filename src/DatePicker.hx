import js.html.*;

using Lambda;

class DatePicker {
    public var container(default,null):DivElement;
    public var oninput:(String)->Void;
    public var input(default,null):InputElement;
    var title:String;
    var pickedDate:Date;
    var displayDate:Date;
    var mode:Mode = DAY;
    public function new(container:DivElement, createInput:Bool = true, title:String = null, initDate:Date = null) {
        this.container = container;
        this.title = title;
        displayDate = initDate != null ? initDate : Date.now();
        displayDate = new Date(displayDate.getFullYear(), displayDate.getMonth(), displayDate.getDate(), displayDate.getHours(), displayDate.getMinutes(), displayDate.getSeconds());
        if(initDate != null) pickedDate = displayDate;
        container.classList.add("datepicker-container");
        if(createInput) {
            input = DOM.input({p:container});
            input.onfocus = show;
            input.oninput = syncPickedDate;
        }
    }

    public function focus() {
        if(input != null) input.focus();
    }

    public function show() {
        buildView();
        container.appendChild(view);
        syncActiveCell();
    }

    public function hide() {
        if(view != null) view.remove();
    }

    var view:DivElement;
    var cells:Array<{div:DivElement, time:Float}>;
    var modeButton:ButtonElement;
    function buildView() {
        if(view != null) return;
        view = DOM.div({c:"picker"});
        if(input != null) view.classList.add("with-input");
        DOM.div({p:view, c:"title", h:title != null ? title : ""});
        var prevButton = DOM.button({p:view, c:"btn-prev", h:"&lt;"});
        modeButton = DOM.button({p:view, c:"btn-mode"});
        var nextButton = DOM.button({p:view, c:"btn-next", h:"&gt;"});
        for(dow in daysOfWeekAbbr)
            DOM.div({p:view, c:"header", h:dow});
        cells = [ for(i in 0 ... 7*6) {div:DOM.div({p:view, c:"cell"}), time:0} ]; // 7 days, 6 rows
        for(cell in cells) {
            cell.div.onclick = () -> {
                displayDate = pickedDate = Date.fromTime(cell.time);
                syncInput();
                mode = switch(mode) {
                    case DAY: DAY;
                    case MONTH: DAY;
                    case YEAR: MONTH;
                    case DECADE: YEAR;
                }
                syncCells();
                syncActiveCell();
            }
        }
        syncCells();

        function moveRange(move:Int) {
            var year = displayDate.getFullYear();
            var month = displayDate.getMonth();
            switch(mode) {
                case DAY: month+=move;
                case MONTH: year+=move;
                case YEAR: year+=move*10;
                case DECADE: year+=move*100;
            }

            // Get a valid range, do these with modulus instead?
            while(month < 0) {
                year--;
                month += 12;
            }
            while(month > 11) {
                year++;
                month -= 12;
            }
            
            displayDate = new Date(year, month, displayDate.getDate(), displayDate.getHours(), displayDate.getMinutes(), displayDate.getSeconds());
            syncCells();
            syncActiveCell();
        }

        prevButton.onclick = moveRange.bind(-1);
        nextButton.onclick = moveRange.bind(1);
        modeButton.onclick = () -> {
            switch(mode){
                case DAY: mode = MONTH;
                case MONTH: mode = YEAR;
                case YEAR: mode = DECADE;
                case DECADE: mode = DECADE;
            }
            syncCells();
            syncActiveCell();
        }
    }

    function syncPickedDate() {
        if(input == null) return;
        var newTime = js.lib.Date.parse(input.value);
        if(Math.isNaN(newTime) || (pickedDate != null && pickedDate.getTime() == newTime)) return;
        displayDate = pickedDate = Date.fromTime(newTime);
        syncCells(true);
        syncActiveCell();
    }

    function syncInput() {
        if(pickedDate == null) return;
        var jsDate:js.lib.Date = cast pickedDate;
        var val = jsDate.toLocaleDateString();
        if(input != null) input.value = val;
        if(mode == DAY && oninput != null) oninput(val);
    }

    var activeCell:DivElement = null;
    function syncActiveCell() {
        if(pickedDate == null) return;        
        var newCell = cells.find((c) -> c.time == pickedDate.getTime());
        if(newCell != null && newCell.div == activeCell) return;
        if(activeCell != null) activeCell.classList.remove("active");
        activeCell = newCell != null ? newCell.div : null;
        if(activeCell != null) activeCell.classList.add("active");
    }

    var curRange:Int = -1;
    var curMode:Mode = null;
    function syncCells(force:Bool = false) {
        // Check if an update is needed
        if(!force && curMode == mode) {
            switch(mode) {
                case DAY:
                    if(displayDate.getMonth() == curRange) return;
                case MONTH:
                    if(displayDate.getFullYear() == curRange) return;
                case YEAR:
                    if(Math.floor(displayDate.getFullYear()/10) == curRange) return;
                case DECADE:
                    if(Math.floor(displayDate.getFullYear()/100) == curRange) return;
            }
        }
        curMode = mode;
        view.classList.remove("day-mode", "month-mode", "year-mode", "decade-mode");
        switch(curMode) {
            case DAY:
                curRange = displayDate.getMonth();
                modeButton.innerHTML = '${monthsFull[displayDate.getMonth()]} ${Std.string(displayDate.getFullYear())}';
                view.classList.add("day-mode");
                for(c in cells) c.div.style.display = "unset";
                var firstOfMonth = Date.fromTime(displayDate.getTime() - ((displayDate.getDate()-1) * millisecPerDay));
                var useTime = firstOfMonth.getTime() - (firstOfMonth.getDay() * millisecPerDay);

                var prev = true;
                for(cell in cells) {
                    var useDate = Date.fromTime(useTime);
                    cell.div.classList.remove("prev", "next");
                    if(useDate.getMonth() != curRange) cell.div.classList.add(prev ? "prev" : "next");
                        else prev = false;
                    cell.div.innerHTML = Std.string(useDate.getDate());
                    cell.time = useDate.getTime();
                    useTime+=millisecPerDay;
                }
            case MONTH:
                curRange = displayDate.getFullYear();
                modeButton.innerHTML = '${Std.string(curRange)}';
                view.classList.add("month-mode");
                for(i in 0 ... cells.length) {
                    var div = cells[i].div;
                    if(i < monthsAbbr.length) {
                        div.classList.remove("prev", "next");
                        div.innerHTML = monthsAbbr[i];
                        cells[i].time = new Date(displayDate.getFullYear(), i, displayDate.getDate(), displayDate.getHours(), displayDate.getMinutes(), displayDate.getSeconds()).getTime();
                    } else {
                        div.style.display = "none";
                    }
                }
            case YEAR:
                curRange = Math.floor(displayDate.getFullYear()/10)*10;
                modeButton.innerHTML = '${Std.string(curRange)} - ${Std.string(curRange+9)}';
                view.classList.add("year-mode");
                for(i in 0 ... cells.length) {
                    var div = cells[i].div;
                    if(i < 12) {
                        var useYear = curRange-1+i;
                        div.classList.remove("prev", "next");
                        if(i == 0) div.classList.add("prev");
                        if(i == 11) div.classList.add("next");
                        div.innerHTML = Std.string(useYear);
                        cells[i].time = new Date(useYear, displayDate.getMonth(), displayDate.getDate(), displayDate.getHours(), displayDate.getMinutes(), displayDate.getSeconds()).getTime();
                    } else {
                        div.style.display = "none";
                    }
                }
            case DECADE:
                curRange = Math.floor(displayDate.getFullYear()/100)*100;
                var yearOffset = (displayDate.getFullYear() - curRange) % 10;
                modeButton.innerHTML = '${Std.string(curRange)} - ${Std.string(curRange+90)}';
                view.classList.add("decade-mode");
                for(i in 0 ... cells.length) {
                    var div = cells[i].div;
                    if(i < 12) {
                        var useYear = (curRange-10)+(i*10);
                        div.classList.remove("prev", "next");
                        if(i == 0) div.classList.add("prev");
                        if(i == 11) div.classList.add("next");
                        div.innerHTML = Std.string(useYear);
                        cells[i].time = new Date(useYear + yearOffset, displayDate.getMonth(), displayDate.getDate(), displayDate.getHours(), displayDate.getMinutes(), displayDate.getSeconds()).getTime();
                    } else {
                        div.style.display = "none";
                    }
                }
        }
    }

    static var daysOfWeekAbbr = [ "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" ];
    static var monthsFull = ["January","February","March","April","May","June","July","August","September","October","November","December"];
    static var monthsAbbr = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

    static inline var millisecPerDay = 1000*60*60*24;
}

enum abstract Mode(Int) {
    var DAY;
    var MONTH;
    var YEAR;
    var DECADE;
}