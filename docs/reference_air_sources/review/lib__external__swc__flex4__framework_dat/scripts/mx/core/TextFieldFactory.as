package mx.core
{
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class TextFieldFactory implements ITextFieldFactory
   {
      
      private static var instance:ITextFieldFactory;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var textFields:Dictionary = new Dictionary(true);
      
      private var fteTextFields:Dictionary = new Dictionary(true);
      
      public function TextFieldFactory()
      {
         super();
      }
      
      public static function getInstance() : ITextFieldFactory
      {
         if(!instance)
         {
            instance = new TextFieldFactory();
         }
         return instance;
      }
      
      public function createTextField(moduleFactory:IFlexModuleFactory) : TextField
      {
         var iter:Object = null;
         var textField:TextField = null;
         var textFieldDictionary:Dictionary = this.textFields[moduleFactory];
         if(Boolean(textFieldDictionary))
         {
            var _loc5_:int = 0;
            var _loc6_:* = textFieldDictionary;
            for(iter in _loc6_)
            {
               textField = TextField(iter);
            }
         }
         if(!textField)
         {
            if(Boolean(moduleFactory))
            {
               textField = TextField(moduleFactory.create("flash.text.TextField"));
            }
            else
            {
               textField = new TextField();
            }
            if(!textFieldDictionary)
            {
               textFieldDictionary = new Dictionary(true);
            }
            textFieldDictionary[textField] = 1;
            this.textFields[moduleFactory] = textFieldDictionary;
         }
         return textField;
      }
      
      public function createFTETextField(moduleFactory:IFlexModuleFactory) : Object
      {
         var iter:Object = null;
         var fteTextField:Object = null;
         var fteTextFieldDictionary:Dictionary = this.fteTextFields[moduleFactory];
         if(Boolean(fteTextFieldDictionary))
         {
            var _loc5_:int = 0;
            var _loc6_:* = fteTextFieldDictionary;
            for(iter in _loc6_)
            {
               fteTextField = iter;
            }
         }
         if(!fteTextField)
         {
            if(Boolean(moduleFactory))
            {
               fteTextField = moduleFactory.create("mx.core.FTETextField");
               fteTextField.fontContext = moduleFactory;
            }
            if(!fteTextFieldDictionary)
            {
               fteTextFieldDictionary = new Dictionary(true);
            }
            fteTextFieldDictionary[fteTextField] = 1;
            this.fteTextFields[moduleFactory] = fteTextFieldDictionary;
         }
         return fteTextField;
      }
   }
}

