import js.Syntax;
import js.html.*;
import js.Browser.document;
import haxe.ds.Either;

using StringTools;

class DOM {
	public static var isIE11:Bool = Syntax.code('!!window.MSInputMethodContext && !!document.documentMode');

	public static inline function e(o:CreateOptions):Element {
		var e = document.createElement(o.t);

		if(null != o.id) e.id = o.id.replace(" ", "-");

		if (o.c != null) {
			switch (o.c) {
				case Left(a):
					e.className = a.join(" ");
				case Right(v):
					e.className = v;
			}
		}
		if(o.p != null)
			if (o.insertBefore!=null)
				o.p.insertBefore(e, o.insertBefore);
			else
				o.p.appendChild(e);
		if(o.title != null)
			e.title = o.title;
		return e;
  	}
	/** Creates a DIV with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param h:String Inner HTML
	**/
	public static function div(?o:DivOptions):DivElement {
    	var eO:CreateOptions = { t:"div" };
		mergeOptions(eO, o);

		var e = e(eO);
		if(o != null && o.h != null)
			e.innerHTML = o.h;

		return cast e;
	}

	/** Creates a BUTTON with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param h:String Inner HTML
	@param fnc:function Binding function for data, it expects a string.
	**/
	public static function button(?o:ButtonOptions):ButtonElement {
    	var eO:CreateOptions = { t:"button" };
		mergeOptions(eO, o);
		var e = e(eO);
		if(o != null && o.h != null)
			e.innerHTML = o.h;
		e.addEventListener("click", () -> {
			if (o.fnc!=null){
				o.fnc(  );
			}
		});
		return cast e;
	}
	/** Creates a LABEL with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param h:String Inner HTML
	@param f:forDiv Html Label for property.
	**/
	public static function label(?o:LabelOptions):LabelElement {
    	var eO:CreateOptions = { t:"label" };
		mergeOptions(eO, o);

		var e = e(eO);
		if(o != null && o.h != null)
			e.innerHTML = o.h;
		if(o != null && o.f != null)
			cast(e,LabelElement).htmlFor=o.f;
		return cast e;
	}
	public static function img(?o:ImgOptions):ImageElement {
		var eO:CreateOptions = { t:"img" };
		mergeOptions(eO, o);

		var e:ImageElement = cast e(eO);
		if(o != null && o.src != null)
			e.src = o.src;
		return e;
	}
	/** Creates an ANCHOR with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param h:String Inner HTML
	@param fnc:function Binding function for data, it expects a string.
	**/
	public static function anchor(?o:AnchorOptions):AnchorElement {
    	var eO:CreateOptions = { t:"a" };
		mergeOptions(eO, o);

		var e:AnchorElement = cast e(eO);
		if(o != null && o.h != null)
			e.innerHTML = o.h;

		if(o != null && o.href != null)
			e.href = o.href;
		else
			e.href="javascript:;";

		if (o != null && o.fnc != null)
			e.addEventListener("click", o.fnc);

		return e;
	}
	/** Creates a SPAN with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param h:String Inner HTML
	**/
	public static function span(?o:SpanOptions):SpanElement {
    	var eO:CreateOptions = { t:"span" };
		mergeOptions(eO, o);

		var e = e(eO);
		if(o != null && o.h != null)
			e.innerHTML = o.h;

		return cast e;
	}
	/** Creates a OL with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	**/
	public static function ol(?o:BaseOptions):UListElement {
    	var eO:CreateOptions = { t:"ol" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
	/** Creates a UL with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	**/
	public static function ul(?o:BaseOptions):UListElement {
    	var eO:CreateOptions = { t:"ul" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
	/** Creates a LI with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param h:String Inner HTML
	**/
	public static function li(?o:LIOptions):LIElement {
    	var eO:CreateOptions = { t:"li" };
		mergeOptions(eO, o);
		var e = e(eO);
		if(o != null && o.h != null)
			e.innerHTML = o.h;
		return cast e;
	}
	/** Creates an INPUT with options {p, c, id, h}
	@param p:Element Parent Dom Element
	@param c:String CSS Class List (Array or space separated)
	@param id:String ID attribute (no spaces!)
	@param type:String Html Input Type
	**/
	public static function input(?o:InputOptions):InputElement {
		var eO:CreateOptions = { t:"input" };
		mergeOptions(eO, o);

		var e:InputElement = cast e(eO);
		if(o != null && o.type != null)
            e.type = o.type;
        if(o != null && o.placeholder != null)
			e.placeholder = o.placeholder;

		return e;
	}
	public static function textarea(?o:BaseOptions):TextAreaElement {
		var eO:CreateOptions = { t:"textarea" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
	public static function table(?o:TableOptions):TableElement {
		var eO:CreateOptions = { t:"table" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
	public static function thead(?o:TableOptions):TableRowElement {
		var eO:CreateOptions = { t:"thead" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
    public static function tbody(?o:TableOptions):TableRowElement {
		var eO:CreateOptions = { t:"tbody" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
	public static function tr(?o:TableOptions):TableRowElement {
		var eO:CreateOptions = { t:"tr" };
		mergeOptions(eO, o);
		var e = e(eO);
		return cast e;
	}
	public static function td(?o:TDOptions):TableCellElement {
		var eO:CreateOptions = { t:"td" };
		mergeOptions(eO, o);
		var e = e(eO);
		if (o.colSpan!=null) e.setAttribute('colSpan', ""+o.colSpan);
		if (o.rowSpan!=null) e.setAttribute('rowSpan', ""+o.rowSpan);
        if(o != null && o.h != null)
			e.innerHTML = o.h;
		return cast e;
	}
	public static function th(?o:TableOptions):TableCellElement {
		var eO:CreateOptions = { t:"th" };
		mergeOptions(eO, o);
		var e = e(eO);
        if(o != null && o.h != null)
			e.innerHTML = o.h;
		return cast e;
	}
	static function mergeOptions(out:BaseOptions, merge:BaseOptions) {
		if(merge != null) {
			out.c = merge.c;
			out.p = merge.p;
			out.id = merge.id;
			out.title = merge.title;
		}
	}

    public static function newEvent(eventName) {
        var event;
        if (!isIE11) {
            event = new Event(eventName);
        } else {
            event = document.createEvent('Event');
            event.initEvent(eventName, true, true);
        }
        return event;
    }
}

typedef BaseOptions = { ?p:DOMElement, ?c:CSSClass<Array<String>, String>, ?id:String, ?insertBefore:DOMElement, ?title:String };
typedef DivOptions = { > BaseOptions, ?h:String };
typedef ButtonOptions = { > BaseOptions, ?h:String, ?fnc:()->Void };
typedef AnchorOptions = { > BaseOptions, ?h:String, ?href:String, ?fnc:()->Void };
typedef SpanOptions = { > BaseOptions, ?h:String };
typedef LabelOptions = { > BaseOptions, ?h:String, ?f:String };
typedef ImgOptions = { > BaseOptions, ?src:String };
typedef LIOptions = { > BaseOptions, ?h:String };
typedef InputOptions = { > BaseOptions, ?type:String, ?placeholder:String };
typedef CreateOptions = { > BaseOptions, t:String };
typedef TableOptions={ > BaseOptions, ?h:String  };
typedef TDOptions={ > BaseOptions, ?h:String, ?colSpan:Int, ?rowSpan:Int  };

abstract CSSClass<A, B>(Either<A, B>) from Either<A, B> to Either<A, B> {
	@:from inline static function fromA<A, B>(a:A):CSSClass<A, B> {
		return Left(a);
	}

	@:from inline static function fromB<A, B>(b:B):CSSClass<A, B> {
		return Right(b);
	}

	@:to inline function toA():Null<A>
		return switch (this) {
			case Left(a): a;
			default: null;
		}

	@:to inline function toB():Null<B>
		return switch (this) {
			case Right(b): b;
			default: null;
		}
}
