package flexlib.scheduling.scheduleClasses.renderers
{
   import flexlib.scheduling.scheduleClasses.ColoredScheduleEntry;
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import flexlib.scheduling.scheduleClasses.SimpleScheduleEntry;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   
   public class ColoredSolidScheduleEntryRenderer extends AbstractSolidScheduleEntryRenderer
   {
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":AbstractSolidScheduleEntryRenderer,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Label,
               "id":"contentLabel"
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"contentText"
            })]};
         }
      });
      
      public function ColoredSolidScheduleEntryRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      override public function set data(value:Object) : void
      {
         var content:ColoredScheduleEntry = null;
         super.data = value;
         entry = value as IScheduleEntry;
         content = ColoredScheduleEntry(entry);
         setStyle("backgroundColor",content.backgroundColor);
         setTextContent(SimpleScheduleEntry(content));
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         super.initialize();
      }
   }
}

