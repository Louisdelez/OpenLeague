package flexlib.controls
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.controls.TextInput;
   import mx.events.PropertyChangeEvent;
   
   public class PromptingTextInput extends TextInput
   {
      
      private var _promptFormat:String = "<font color=\"#999999\"><i>[prompt]</i></font>";
      
      private var _displayAsPassword:Boolean = false;
      
      private var _currentlyFocused:Boolean = false;
      
      private var _prompt:String = "";
      
      private var _textEmpty:Boolean;
      
      public function PromptingTextInput()
      {
         super();
         _textEmpty = true;
         addEventListener(Event.CHANGE,handleChange);
         addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
         addEventListener(FocusEvent.FOCUS_OUT,handleFocusOut);
      }
      
      protected function handleFocusIn(event:FocusEvent) : void
      {
         _currentlyFocused = true;
         if(_textEmpty)
         {
            super.htmlText = "";
            validateNow();
         }
      }
      
      public function set promptFormat(value:String) : void
      {
         _promptFormat = value;
         if(_promptFormat.indexOf("[prompt]") < 0)
         {
         }
         invalidateDisplayList();
      }
      
      override public function get text() : String
      {
         if(_textEmpty)
         {
            return "";
         }
         return super.text;
      }
      
      public function get prompt() : String
      {
         return _prompt;
      }
      
      protected function handleFocusOut(event:FocusEvent) : void
      {
         _currentlyFocused = false;
         invalidateDisplayList();
      }
      
      [Bindable]
      private function set _979805852prompt(value:String) : void
      {
         _prompt = value;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [NonCommittingChangeEvent("change")]
      [CollapseWhiteSpace]
      [Bindable("textChanged")]
      override public function set text(value:String) : void
      {
         _textEmpty = !value || value.length == 0;
         super.text = value;
         invalidateDisplayList();
      }
      
      public function get promptFormat() : String
      {
         return _promptFormat;
      }
      
      override public function set displayAsPassword(value:Boolean) : void
      {
         _displayAsPassword = value;
         super.displayAsPassword = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set prompt(value:String) : void
      {
         var oldValue:Object = null;
         oldValue = this.prompt;
         if(oldValue !== value)
         {
            this._979805852prompt = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"prompt",oldValue,value));
         }
      }
      
      override public function get displayAsPassword() : Boolean
      {
         return _displayAsPassword;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var oldVal:Boolean = false;
         if(_textEmpty && _prompt != "" && !_currentlyFocused)
         {
            if(_promptFormat == "")
            {
               super.text = _prompt;
            }
            else
            {
               super.htmlText = _promptFormat.replace(/\[prompt\]/g,_prompt);
            }
            if(super.displayAsPassword)
            {
               oldVal = _displayAsPassword;
               super.displayAsPassword = false;
               _displayAsPassword = oldVal;
            }
         }
         else if(super.displayAsPassword != _displayAsPassword)
         {
            super.displayAsPassword = _displayAsPassword;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      protected function handleChange(event:Event) : void
      {
         _textEmpty = super.text.length == 0;
      }
   }
}

