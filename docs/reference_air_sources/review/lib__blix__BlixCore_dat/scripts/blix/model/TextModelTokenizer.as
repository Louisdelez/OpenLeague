package blix.model
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class TextModelTokenizer implements ITextModel, IDestructible
   {
      
      protected var _textChanged:Signal = new Signal();
      
      protected var _text:String;
      
      protected var _decoratedTextModel:ITextModel;
      
      protected var _tokens:Vector.<String>;
      
      public function TextModelTokenizer(param1:ITextModel, param2:Vector.<String> = null)
      {
         super();
         this._decoratedTextModel = param1;
         this._decoratedTextModel.getTextChanged().add(this.refreshText);
         this._tokens = param2;
         this._text = this.generateText();
      }
      
      protected function refreshText() : void
      {
         var _loc1_:String = this._text;
         this._text = this.generateText();
         this._textChanged.dispatch(this,_loc1_,this._text);
      }
      
      private function generateText() : String
      {
         var _loc1_:String = this._decoratedTextModel.getText();
         if(this._tokens == null)
         {
            return _loc1_;
         }
         var _loc2_:uint = this._tokens.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _loc1_.replace("{" + _loc3_ + "}",this._tokens[_loc3_]);
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getTextChanged() : ISignal
      {
         return this._textChanged;
      }
      
      public function getText() : String
      {
         return this._text;
      }
      
      public function getTokens() : Vector.<String>
      {
         return this._tokens;
      }
      
      public function setTokens(param1:Vector.<String>) : void
      {
         this._tokens = param1;
         this.refreshText();
      }
      
      public function destroy() : void
      {
         this._decoratedTextModel.getTextChanged().remove(this.refreshText);
      }
   }
}

