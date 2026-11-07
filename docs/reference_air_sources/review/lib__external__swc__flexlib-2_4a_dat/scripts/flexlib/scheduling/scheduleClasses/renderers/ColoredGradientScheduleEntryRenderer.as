package flexlib.scheduling.scheduleClasses.renderers
{
   import flexlib.scheduling.scheduleClasses.ColoredScheduleEntry;
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import flexlib.scheduling.scheduleClasses.SimpleScheduleEntry;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.utils.ColorUtil;
   
   public class ColoredGradientScheduleEntryRenderer extends AbstractGradientScheduleEntryRenderer
   {
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":AbstractGradientScheduleEntryRenderer,
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
      
      public function ColoredGradientScheduleEntryRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      override public function set data(value:Object) : void
      {
         var content:ColoredScheduleEntry = null;
         var newColor:uint = 0;
         super.data = value;
         entry = value as IScheduleEntry;
         content = ColoredScheduleEntry(entry);
         newColor = uint(ColorUtil.adjustBrightness2(content.backgroundColor,25));
         setStyle("fillColors",[newColor,content.backgroundColor]);
         setTextContent(SimpleScheduleEntry(content));
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         super.initialize();
      }
   }
}

