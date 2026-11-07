package mx.controls.textClasses
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import mx.core.UIComponent;
   import mx.styles.StyleManager;
   import mx.utils.StringUtil;
   
   public class TextRange
   {
      
      private static var htmlTextField:TextField;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var textField:TextField;
      
      private var _beginIndex:int;
      
      private var _endIndex:int;
      
      private var _modifiesSelection:Boolean;
      
      private var _owner:UIComponent;
      
      public function TextRange(owner:UIComponent, modifiesSelection:Boolean = false, beginIndex:int = -1, endIndex:int = -1)
      {
         super();
         this._owner = owner;
         try
         {
            this.textField = this._owner["textArea"].getTextField();
         }
         catch(e:Error)
         {
            textField = this["_owner"].getTextField();
         }
         this._modifiesSelection = modifiesSelection;
         if(!this._modifiesSelection)
         {
            if(beginIndex < 0)
            {
               beginIndex = 0;
            }
            if(beginIndex > this.textField.length)
            {
               beginIndex = this.textField.length;
            }
            if(endIndex < 0 || endIndex > this.textField.length)
            {
               endIndex = this.textField.length;
            }
            this._beginIndex = beginIndex;
            this._endIndex = endIndex;
         }
         else
         {
            if(beginIndex < 0 || beginIndex > this.textField.length)
            {
               beginIndex = this.textField.selectionBeginIndex;
            }
            if(endIndex < 0 || endIndex > this.textField.length)
            {
               endIndex = this.textField.selectionEndIndex;
            }
            this.textField.selectable = true;
            if(beginIndex != this.textField.selectionBeginIndex || endIndex != this.textField.selectionEndIndex)
            {
               this.textField.setSelection(beginIndex,endIndex);
            }
         }
      }
      
      public function get beginIndex() : int
      {
         if(this._modifiesSelection)
         {
            return this.textField.selectionBeginIndex;
         }
         return this._beginIndex;
      }
      
      public function set beginIndex(value:int) : void
      {
         if(this._modifiesSelection)
         {
            this.textField.setSelection(value,this.textField.selectionEndIndex);
         }
         else
         {
            this._beginIndex = value;
         }
      }
      
      public function get bullet() : Boolean
      {
         return this.getTextFormat().bullet;
      }
      
      public function set bullet(value:Boolean) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.bullet = value;
         this.setTextFormat(tf);
      }
      
      public function get color() : Object
      {
         return this.getTextFormat().color;
      }
      
      public function set color(value:Object) : void
      {
         var tf:TextFormat = this.getTextFormat();
         var colorNumber:uint = uint(this.owner.styleManager.getColorName(value));
         if(colorNumber != StyleManager.NOT_A_COLOR)
         {
            value = colorNumber;
         }
         else
         {
            value = 0;
         }
         tf.color = value;
         this.setTextFormat(tf);
      }
      
      public function get endIndex() : int
      {
         if(this._modifiesSelection)
         {
            return this.textField.selectionEndIndex;
         }
         return this._endIndex;
      }
      
      public function set endIndex(value:int) : void
      {
         if(this._modifiesSelection)
         {
            this.textField.setSelection(this.textField.selectionBeginIndex,value);
         }
         else
         {
            this._endIndex = value;
         }
      }
      
      public function get fontFamily() : String
      {
         return this.getTextFormat().font;
      }
      
      public function set fontFamily(value:String) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.font = StringUtil.trimArrayElements(value,",");
         this.setTextFormat(tf);
      }
      
      public function get fontSize() : int
      {
         return int(this.getTextFormat().size);
      }
      
      public function set fontSize(value:int) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.size = value;
         this.setTextFormat(tf);
      }
      
      public function get fontStyle() : String
      {
         return Boolean(this.getTextFormat().italic) ? "italic" : "normal";
      }
      
      public function set fontStyle(value:String) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.italic = value == "italic" ? true : false;
         this.setTextFormat(tf);
      }
      
      public function get fontWeight() : String
      {
         return Boolean(this.getTextFormat().bold) ? "bold" : "normal";
      }
      
      public function set fontWeight(value:String) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.bold = value == "bold" ? true : false;
         this.setTextFormat(tf);
      }
      
      public function get htmlText() : String
      {
         if(this.beginIndex == this.endIndex)
         {
            return "";
         }
         if(!htmlTextField)
         {
            htmlTextField = new TextField();
            htmlTextField.multiline = true;
         }
         htmlTextField.defaultTextFormat = this.textField.defaultTextFormat;
         htmlTextField.htmlText = "";
         htmlTextField.insertXMLText(0,0,this.textField.getXMLText(this.beginIndex,this.endIndex));
         return htmlTextField.htmlText;
      }
      
      public function set htmlText(value:String) : void
      {
         if(!htmlTextField)
         {
            htmlTextField = new TextField();
            htmlTextField.multiline = true;
         }
         htmlTextField.defaultTextFormat = this.textField.defaultTextFormat;
         htmlTextField.htmlText = value;
         var length:int = htmlTextField.length;
         var oldBeginIndex:int = this.beginIndex;
         this.textField.insertXMLText(this.beginIndex,this.endIndex,htmlTextField.getXMLText());
         if(oldBeginIndex == 0 && this.beginIndex > 0)
         {
            this.beginIndex = 0;
         }
         this.endIndex = this.beginIndex + length;
      }
      
      public function get kerning() : Boolean
      {
         return Boolean(this.getTextFormat().kerning);
      }
      
      public function set kerning(value:Boolean) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.kerning = value;
         this.setTextFormat(tf);
      }
      
      public function get letterSpacing() : Number
      {
         return Number(this.getTextFormat().letterSpacing);
      }
      
      public function set letterSpacing(value:Number) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.letterSpacing = value;
         this.setTextFormat(tf);
      }
      
      public function get modifiesSelection() : Boolean
      {
         return this._modifiesSelection;
      }
      
      public function get owner() : UIComponent
      {
         return this._owner;
      }
      
      public function set owner(value:UIComponent) : void
      {
         this._owner = value;
         try
         {
            this.textField = this._owner["textArea"]["textField"];
         }
         catch(e:Error)
         {
            textField = _owner["textField"];
         }
      }
      
      public function get text() : String
      {
         return this.textField.text.substring(this.beginIndex,this.endIndex);
      }
      
      public function set text(value:String) : void
      {
         var oldBeginIndex:int = this.beginIndex;
         this.textField.replaceText(this.beginIndex,this.endIndex,value);
         if(oldBeginIndex == 0 && this.beginIndex > 0)
         {
            this.beginIndex = 0;
         }
         this.endIndex = this.beginIndex + value.length;
      }
      
      public function get textAlign() : String
      {
         return this.getTextFormat().align;
      }
      
      public function set textAlign(value:String) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.align = value;
         this.setTextFormat(tf);
      }
      
      public function get textDecoration() : String
      {
         return Boolean(this.getTextFormat().underline) ? "underline" : "normal";
      }
      
      public function set textDecoration(value:String) : void
      {
         var tf:TextFormat = this.getTextFormat();
         tf.underline = value == "underline" ? true : false;
         this.setTextFormat(tf);
      }
      
      public function get url() : String
      {
         return this.getTextFormat().url;
      }
      
      public function set url(value:String) : void
      {
         var tf:TextFormat = this.getTextFormat();
         if(value != "")
         {
            tf.url = value;
            tf.target = "_blank";
         }
         else if(tf.url != "")
         {
            tf.url = "";
            tf.target = "";
         }
         this.setTextFormat(tf);
      }
      
      private function getTextFormat() : TextFormat
      {
         var tf:TextFormat = null;
         if(this._modifiesSelection && this.beginIndex == this.endIndex)
         {
            tf = this.textField.defaultTextFormat;
         }
         else
         {
            tf = this.textField.getTextFormat(this.beginIndex,this.endIndex);
         }
         return tf;
      }
      
      private function setTextFormat(tf:TextFormat) : void
      {
         if(this._modifiesSelection && this.beginIndex == this.endIndex)
         {
            this.textField.defaultTextFormat = tf;
         }
         else
         {
            this.textField.setTextFormat(tf,this.beginIndex,this.endIndex);
         }
      }
   }
}

