package flexlib.scheduling.scheduleClasses.renderers
{
   import mx.containers.Box;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   
   public class BackgroundLayoutItemRenderer extends Box
   {
      
      public var _bindingsByDestination:Object;
      
      public var _bindingsBeginWithWord:Object;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":Box});
      
      public function BackgroundLayoutItemRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         super.initialize();
      }
   }
}

