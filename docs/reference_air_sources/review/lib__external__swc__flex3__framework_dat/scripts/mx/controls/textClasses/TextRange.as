package mx.controls.textClasses
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.styles.StyleManager;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class TextRange
   {
      
      private static var htmlTextField:TextField;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _beginIndex:int;
      
      private var textField:TextField;
      
      private var _modifiesSelection:Boolean;
      
      private var _endIndex:int;
      
      private var _owner:UIComponent;
      
      public function TextRange(owner:UIComponent, modifiesSelection:Boolean = false, beginIndex:int = -1, endIndex:int = -1)
      {
         super();
         _owner = owner;
         try
         {
            textField = _owner["textArea"].mx_internal::getTextField();
         }
         catch(e:Error)
         {
            textField = this["_owner"].mx_internal::getTextField();
         }
         _modifiesSelection = modifiesSelection;
         if(!_modifiesSelection)
         {
            if(beginIndex < 0)
            {
               beginIndex = 0;
            }
            if(beginIndex > textField.length)
            {
               beginIndex = textField.length;
            }
            if(endIndex < 0 || endIndex > textField.length)
            {
               endIndex = textField.length;
            }
            _beginIndex = beginIndex;
            _endIndex = endIndex;
         }
         else
         {
            if(beginIndex < 0 || beginIndex > textField.length)
            {
               beginIndex = textField.selectionBeginIndex;
            }
            if(endIndex < 0 || endIndex > textField.length)
            {
               endIndex = textField.selectionEndIndex;
            }
            textField.selectable = true;
            if(beginIndex != textField.selectionBeginIndex || endIndex != textField.selectionEndIndex)
            {
               textField.setSelection(beginIndex,endIndex);
            }
         }
      }
      
      public function set textDecoration(value:String) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.underline = value == "underline" ? true : false;
         setTextFormat(tf);
      }
      
      public function get bullet() : Boolean
      {
         return getTextFormat().bullet;
      }
      
      public function set bullet(value:Boolean) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.bullet = value;
         setTextFormat(tf);
      }
      
      public function set color(value:Object) : void
      {
         var tf:TextFormat = getTextFormat();
         var colorNumber:uint = StyleManager.getColorName(value);
         if(colorNumber != StyleManager.NOT_A_COLOR)
         {
            value = colorNumber;
         }
         else
         {
            value = 0;
         }
         tf.color = value;
         setTextFormat(tf);
      }
      
      private function getTextFormat() : TextFormat
      {
         var tf:TextFormat = null;
         if(_modifiesSelection && beginIndex == endIndex)
         {
            tf = textField.defaultTextFormat;
         }
         else
         {
            tf = textField.getTextFormat(beginIndex,endIndex);
         }
         return tf;
      }
      
      private function setTextFormat(tf:TextFormat) : void
      {
         if(_modifiesSelection && beginIndex == endIndex)
         {
            textField.defaultTextFormat = tf;
         }
         else
         {
            textField.setTextFormat(tf,beginIndex,endIndex);
         }
      }
      
      public function set fontStyle(value:String) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.italic = value == "italic" ? true : false;
         setTextFormat(tf);
      }
      
      public function get kerning() : Boolean
      {
         return Boolean(getTextFormat().kerning);
      }
      
      public function set fontWeight(value:String) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.bold = value == "bold" ? true : false;
         setTextFormat(tf);
      }
      
      public function set beginIndex(value:int) : void
      {
         if(_modifiesSelection)
         {
            textField.setSelection(value,textField.selectionEndIndex);
         }
         else
         {
            _beginIndex = value;
         }
      }
      
      public function get fontFamily() : String
      {
         return getTextFormat().font;
      }
      
      public function get modifiesSelection() : Boolean
      {
         return _modifiesSelection;
      }
      
      public function set kerning(value:Boolean) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.kerning = value;
         setTextFormat(tf);
      }
      
      public function set textAlign(value:String) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.align = value;
         setTextFormat(tf);
      }
      
      public function set url(value:String) : void
      {
         var tf:TextFormat = getTextFormat();
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
         setTextFormat(tf);
      }
      
      public function get textAlign() : String
      {
         return getTextFormat().align;
      }
      
      public function set fontSize(value:int) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.size = value;
         setTextFormat(tf);
      }
      
      public function set text(value:String) : void
      {
         var oldBeginIndex:int = beginIndex;
         textField.replaceText(beginIndex,endIndex,value);
         if(oldBeginIndex == 0 && beginIndex > 0)
         {
            beginIndex = 0;
         }
         endIndex = beginIndex + value.length;
      }
      
      public function get fontStyle() : String
      {
         return Boolean(getTextFormat().italic) ? "italic" : "normal";
      }
      
      public function get color() : Object
      {
         return getTextFormat().color;
      }
      
      public function set fontFamily(value:String) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.font = StringUtil.trimArrayElements(value,",");
         setTextFormat(tf);
      }
      
      public function get fontWeight() : String
      {
         return Boolean(getTextFormat().bold) ? "bold" : "normal";
      }
      
      public function get beginIndex() : int
      {
         if(_modifiesSelection)
         {
            return textField.selectionBeginIndex;
         }
         return _beginIndex;
      }
      
      public function set owner(value:UIComponent) : void
      {
         _owner = value;
         try
         {
            textField = _owner["textArea"]["textField"];
         }
         catch(e:Error)
         {
            textField = _owner["textField"];
         }
      }
      
      public function set endIndex(value:int) : void
      {
         if(_modifiesSelection)
         {
            textField.setSelection(textField.selectionBeginIndex,value);
         }
         else
         {
            _endIndex = value;
         }
      }
      
      public function get url() : String
      {
         return getTextFormat().url;
      }
      
      public function set htmlText(value:String) : void
      {
         if(!htmlTextField)
         {
            htmlTextField = new TextField();
            htmlTextField.multiline = true;
         }
         htmlTextField.defaultTextFormat = textField.defaultTextFormat;
         htmlTextField.htmlText = value;
         var length:int = htmlTextField.length;
         var oldBeginIndex:int = beginIndex;
         textField.insertXMLText(beginIndex,endIndex,htmlTextField.getXMLText());
         if(oldBeginIndex == 0 && beginIndex > 0)
         {
            beginIndex = 0;
         }
         endIndex = beginIndex + length;
      }
      
      public function get textDecoration() : String
      {
         return Boolean(getTextFormat().underline) ? "underline" : "normal";
      }
      
      public function get endIndex() : int
      {
         if(_modifiesSelection)
         {
            return textField.selectionEndIndex;
         }
         return _endIndex;
      }
      
      public function get htmlText() : String
      {
         if(beginIndex == endIndex)
         {
            return "";
         }
         if(!htmlTextField)
         {
            htmlTextField = new TextField();
            htmlTextField.multiline = true;
         }
         htmlTextField.defaultTextFormat = textField.defaultTextFormat;
         htmlTextField.htmlText = "";
         htmlTextField.insertXMLText(0,0,textField.getXMLText(beginIndex,endIndex));
         return htmlTextField.htmlText;
      }
      
      public function get owner() : UIComponent
      {
         return _owner;
      }
      
      public function set letterSpacing(value:Number) : void
      {
         var tf:TextFormat = getTextFormat();
         tf.letterSpacing = value;
         setTextFormat(tf);
      }
      
      public function get text() : String
      {
         return textField.text.substring(beginIndex,endIndex);
      }
      
      public function get letterSpacing() : Number
      {
         return Number(getTextFormat().letterSpacing);
      }
      
      public function get fontSize() : int
      {
         return int(getTextFormat().size);
      }
   }
}

