class DDW.Components.DefaultTextBox extends DDW.Components.DisplayObject
{
   var _filters;
   var _height;
   var _layer;
   var _letterSpacing;
   var _redrawList;
   var _textField;
   var _visible;
   var _width;
   var _x;
   var _y;
   var addEventListener;
   var format;
   var graphics;
   var height;
   var id;
   var needsRedraw;
   var removeEventListener;
   var width;
   var x;
   var y;
   var _class = "DefaultTextBox";
   var _text = "";
   var _align = "left";
   var _bold = false;
   var _font = "Arial";
   var _fontSize = 12;
   var _leading = 2;
   var _kerning = false;
   var _textColor = 0;
   function DefaultTextBox(libraryName, mx)
   {
      super(libraryName);
      this.format = new TextFormat();
      if(mx != null)
      {
         this.x = mx.x;
         this.y = mx.y;
         this.width = mx.width;
         this.height = mx.height;
         this.text = mx.text;
         this.align = mx.align;
         this.bold = mx.bold;
         this.font = mx.font;
         this.fontSize = mx.fontSize;
         this.leading = mx.leading;
         this.textColor = mx.textColor;
      }
      else
      {
         this.width = 100;
         this.height = 100;
      }
      this.addEventListener(DDW.Events.Event.ADDED_TO_STAGE,this,this.addedToStage);
   }
   function get text()
   {
      return this._text;
   }
   function set text(value)
   {
      this._text = value;
      if(this._textField != null)
      {
         this._textField.text = value;
         this._textField.setTextFormat(this.format);
      }
   }
   function get htmlText()
   {
      return this._text;
   }
   function set htmlText(value)
   {
      this._text = value;
      if(this._textField != null)
      {
         this._textField.multiline = true;
         this._textField.wordWrap = true;
         this._textField.antiAliasType = "advanced";
         this._textField.html = true;
         this._textField.htmlText = value;
      }
   }
   function set visible(value)
   {
      if(this._textField != null)
      {
         this._textField._visible = value;
      }
      this._visible = value;
      if(this.graphics != null)
      {
         this.graphics._visible = value;
      }
      this._redrawList.push(["_visible",this._visible]);
      this.needsRedraw();
   }
   function get align()
   {
      return this._align;
   }
   function set align(value)
   {
      this._align = value;
      this.format.align = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get bold()
   {
      return this._bold;
   }
   function set bold(value)
   {
      this._bold = value;
      this.format.bold = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.bold);
      }
   }
   function get font()
   {
      return this._font;
   }
   function set font(value)
   {
      this._font = value;
      this.format.font = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get fontSize()
   {
      return this._fontSize;
   }
   function set fontSize(value)
   {
      this._fontSize = value;
      this.format.size = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get leading()
   {
      return this._leading;
   }
   function set leading(value)
   {
      this._leading = value;
      this.format.leading = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get kerning()
   {
      return this._kerning;
   }
   function set kerning(value)
   {
      this._kerning = value;
      this.format.kerning = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get letterSpacing()
   {
      return this._letterSpacing;
   }
   function set letterSpacing(value)
   {
      this._letterSpacing = value;
      this.format.letterSpacing = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get textColor()
   {
      return this._textColor;
   }
   function set textColor(value)
   {
      this._textColor = value;
      this.format.color = value;
      if(this._textField != null)
      {
         this._textField.setTextFormat(this.format);
      }
   }
   function get filters()
   {
      return this._filters;
   }
   function set filters(value)
   {
      this._filters = value;
      if(this._textField != null)
      {
         this._textField.filters = value;
      }
      else
      {
         this._redrawList.push(["filters",this._filters]);
         this.needsRedraw();
      }
   }
   function addedToStage(event)
   {
      super.addedToStage();
      this.addEventListener(DDW.Events.Event.REMOVED_FROM_STAGE,this,this.removedFromStage);
   }
   function removedFromStage(event)
   {
      super.removedFromStage();
      this.removeEventListener(DDW.Events.Event.REMOVED_FROM_STAGE,this.removedFromStage);
      this.graphics = null;
   }
   function addTo(parent)
   {
      this._textField = parent.graphics.createTextField("_" + this.id,this._layer,this.x,this.y,this.width,this.height);
      this._textField.text = this._text;
      this._textField.embedFonts = true;
      this._textField.selectable = false;
      this._textField.antiAliasType = "advanced";
      this._textField.multiline = true;
      this._textField.wordWrap = true;
      this.format.align = this._align;
      this.format.size = this._fontSize;
      this.format.font = this._font;
      this.format.bold = this._bold;
      this.format.leading = this._leading;
      this._textField.textColor = this._textColor;
      this._textField.setTextFormat(this.format);
   }
   function getMetrics()
   {
      var _loc2_ = new DDW.Utils.TextMetrics(this._x,this._y,this._width,this._height,this._text,this._align,this._bold,this._font,this._fontSize,this._leading,this._textColor);
      return _loc2_;
   }
}
