package blix.components.validation
{
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.validation.IValidator;
   import blix.validation.ValidationError;
   
   public class ValidationErrorTextView extends ValidationErrorView
   {
      
      private var text:Text;
      
      public function ValidationErrorTextView(param1:Context, param2:Vector.<IValidator> = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.text = new Text(this);
         setTimelineChildByName("textField",this.text);
      }
      
      override protected function showErrors(param1:Vector.<ValidationError>) : void
      {
         super.showErrors(param1);
         if(param1.length == 0)
         {
            this.text.setText("");
         }
         else
         {
            this.text.setTextModel(param1[0].validationError);
         }
      }
   }
}

