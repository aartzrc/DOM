import js.Browser.*;

class Example {
    static function main() {
        var datePicker = new DatePicker(DOM.div({p:document.body}));

        // Show the datePicker
        //datePicker.focus();

        // Auto-hide the datePicker when a date it chosen
        datePicker.oninput = (val) -> {
            trace(val);
            datePicker.hide();
        }
    }
}