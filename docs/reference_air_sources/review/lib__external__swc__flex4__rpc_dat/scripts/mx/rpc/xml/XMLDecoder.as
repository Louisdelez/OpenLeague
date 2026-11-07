package mx.rpc.xml
{
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.DescribeTypeCache;
   import mx.utils.ObjectProxy;
   import mx.utils.URLUtil;
   import mx.utils.XMLUtil;
   import mx.utils.object_proxy;
   
   [ExcludeClass]
   public class XMLDecoder extends SchemaProcessor implements IXMLDecoder
   {
      
      public static var listClass:Class = ArrayCollection;
      
      protected var document:XML;
      
      private var log:ILogger;
      
      private var _makeObjectsBindable:Boolean;
      
      private var _recordXSIType:Boolean;
      
      private var _typeRegistry:SchemaTypeRegistry;
      
      public function XMLDecoder()
      {
         super();
         this.log = Log.getLogger("mx.rpc.xml.XMLDecoder");
         this.typeRegistry = SchemaTypeRegistry.getInstance();
      }
      
      public static function getUnqualifiedClassName(object:Object) : String
      {
         var name:String = null;
         if(object is String)
         {
            name = object as String;
         }
         else
         {
            name = getQualifiedClassName(object);
         }
         var index:int = name.indexOf("::");
         if(index != -1)
         {
            name = name.substr(index + 2);
         }
         return name;
      }
      
      public function get makeObjectsBindable() : Boolean
      {
         return this._makeObjectsBindable;
      }
      
      public function set makeObjectsBindable(value:Boolean) : void
      {
         this._makeObjectsBindable = value;
      }
      
      public function get recordXSIType() : Boolean
      {
         return this._recordXSIType;
      }
      
      public function set recordXSIType(value:Boolean) : void
      {
         this._recordXSIType = value;
      }
      
      public function get typeRegistry() : SchemaTypeRegistry
      {
         return this._typeRegistry;
      }
      
      public function set typeRegistry(value:SchemaTypeRegistry) : void
      {
         this._typeRegistry = value;
      }
      
      public function decode(xml:*, name:QName = null, type:QName = null, definition:XML = null) : *
      {
         var content:* = undefined;
         var elementDefinition:XML = null;
         if(!(xml is XML) && !(xml is XMLList) && !(xml is String))
         {
            throw new ArgumentError("The xml argument must be of type XML, XMLList or String.");
         }
         if(xml is XML)
         {
            this.document = xml;
         }
         else if(xml is XMLList)
         {
            if(XMLList(xml).length() != 1)
            {
               throw new ArgumentError("The xml argument must have a length of 1 when passed as an XMLList.");
            }
            this.document = XMLList(xml)[0];
         }
         else if(xml is String)
         {
            try
            {
               this.document = new XML(xml);
            }
            catch(e:Error)
            {
               throw new ArgumentError("The xml argument does not contain valid xml. " + xml);
            }
         }
         this.preProcessXML(this.document);
         if(type != null)
         {
            content = this.createContent(type);
            this.decodeType(type,content,name,this.document);
         }
         else
         {
            elementDefinition = definition;
            if(elementDefinition == null)
            {
               elementDefinition = schemaManager.getNamedDefinition(name,constants.elementTypeQName);
            }
            if(elementDefinition == null)
            {
               content = this.createContent(type);
               this.decodeType(constants.anyTypeQName,content,name,this.document);
            }
            else
            {
               content = this.decodeElementTopLevel(elementDefinition,name,this.document);
               if(definition == null)
               {
                  schemaManager.releaseScope();
               }
            }
         }
         if(content is ContentProxy)
         {
            content = ContentProxy(content).object_proxy::content;
         }
         return content;
      }
      
      public function decodeAll(definition:XML, parent:*, name:QName, valueElements:XMLList, context:DecodingContext = null, isRequired:Boolean = true) : Boolean
      {
         var childDefinition:XML = null;
         if(context == null)
         {
            context = new DecodingContext();
         }
         var minOccurs:uint = getMinOccurs(definition);
         var allElements:XMLList = definition.elements();
         var hasSiblings:Boolean = allElements.length() > 1 || context.hasContextSiblings;
         var requireChild:Boolean = isRequired && minOccurs > 0;
         var groupSatisfied:Boolean = !requireChild;
         for each(childDefinition in allElements)
         {
            context.index = 0;
            context.anyIndex = 0;
            if(childDefinition.name() == constants.annotationQName)
            {
               groupSatisfied = true;
            }
            else if(childDefinition.name() == constants.elementTypeQName)
            {
               if(!this.decodeGroupElement(childDefinition,parent,valueElements,context,requireChild,hasSiblings))
               {
                  break;
               }
            }
            else if(childDefinition.name() == constants.anyQName)
            {
               if(!this.decodeAnyElement(childDefinition,parent,name,valueElements,context,requireChild))
               {
                  break;
               }
            }
            groupSatisfied = true;
         }
         return groupSatisfied;
      }
      
      public function decodeAnyType(parent:*, name:QName, valueElements:XMLList) : void
      {
         var elementVal:XML = null;
         var propertyName:QName = null;
         var propertyVal:* = undefined;
         var xsiType:QName = null;
         for each(elementVal in valueElements)
         {
            propertyName = elementVal.name() as QName;
            xsiType = this.getXSIType(elementVal);
            if(xsiType != null)
            {
               propertyVal = this.createContent();
               this.decodeType(schemaManager.schemaDatatypes.anyTypeQName,propertyVal,propertyName,elementVal);
            }
            else
            {
               propertyVal = this.marshallBuiltInType(schemaManager.schemaDatatypes.anyTypeQName,parent,propertyName,elementVal);
            }
            this.setValue(parent,propertyName,propertyVal,xsiType);
         }
      }
      
      public function decodeAnyElement(definition:XML, parent:*, name:QName, valueElements:XMLList, context:DecodingContext = null, isRequired:Boolean = true) : Boolean
      {
         var includedNamespaces:Array = null;
         var targetNamespace:String = null;
         var element:XML = null;
         var processContents:String = null;
         var namespacesString:String = null;
         var propertyName:QName = null;
         var any:* = undefined;
         var elementVal:* = undefined;
         if(context == null)
         {
            context = new DecodingContext();
         }
         var allowTargetNamespace:Boolean = true;
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(definition != null)
         {
            processContents = definition["processContents"];
            namespacesString = definition["namespace"];
            if(namespacesString != "" && namespacesString != "##any")
            {
               if(schemaManager.currentSchema != null && schemaManager.currentSchema.targetNamespace != null)
               {
                  targetNamespace = schemaManager.currentSchema.targetNamespace.uri;
               }
               if(namespacesString == "##other")
               {
                  allowTargetNamespace = false;
               }
               else
               {
                  if(namespacesString.indexOf("##targetNamespace") >= 0)
                  {
                     namespacesString = namespacesString.replace("##targetNamespace",targetNamespace);
                  }
                  includedNamespaces = namespacesString.split(" ");
               }
            }
         }
         var applicableValues:XMLList = this.getApplicableValues(parent,valueElements,null,context,maxOccurs);
         for each(element in applicableValues)
         {
            propertyName = element.name() as QName;
            if(!allowTargetNamespace && URLUtil.urisEqual(propertyName.uri,targetNamespace))
            {
               break;
            }
            if(this.includeNamespace(propertyName.uri,includedNamespaces))
            {
               if(processContents == "skip")
               {
                  elementVal = element.toXMLString();
               }
               else
               {
                  elementVal = element;
               }
               this.decodeAnyType(parent,propertyName,new XMLList(elementVal));
               if(context.anyIndex < 0)
               {
                  context.anyIndex = context.index + 0;
               }
               ++context.index;
            }
         }
         return true;
      }
      
      public function decodeAnyAttribute(definition:XML, parent:*, value:* = undefined, restriction:XML = null) : void
      {
         var xml:XML = null;
         var includedNamespaces:Array = null;
         var allowTargetNamespace:Boolean = false;
         var targetNamespace:String = null;
         var namespacesString:String = null;
         var attributes:XMLList = null;
         var attribute:XML = null;
         var attributeName:QName = null;
         var attributeValue:* = undefined;
         if(value !== undefined && value is XML)
         {
            xml = value as XML;
            allowTargetNamespace = true;
            namespacesString = definition["namespace"];
            if(namespacesString != "" && namespacesString != "##any")
            {
               if(schemaManager.currentSchema != null && schemaManager.currentSchema.targetNamespace != null)
               {
                  targetNamespace = schemaManager.currentSchema.targetNamespace.uri;
               }
               if(namespacesString == "##other")
               {
                  allowTargetNamespace = false;
               }
               else
               {
                  if(namespacesString.indexOf("##targetNamespace") >= 0)
                  {
                     namespacesString = namespacesString.replace("##targetNamespace",targetNamespace);
                  }
                  includedNamespaces = namespacesString.split(" ");
               }
            }
            attributes = xml.attributes();
            for each(attribute in attributes)
            {
               attributeName = attribute.name() as QName;
               if(!(!allowTargetNamespace && URLUtil.urisEqual(attributeName.uri,targetNamespace)))
               {
                  if(this.includeNamespace(attributeName.uri,includedNamespaces))
                  {
                     attributeValue = this.getAttribute(value,attributeName);
                     if(attributeValue != null)
                     {
                        this.setAttribute(parent,attributeName,attributeValue);
                     }
                  }
               }
            }
         }
      }
      
      public function decodeAttribute(definition:XML, parent:*, value:* = undefined, restriction:XML = null) : void
      {
         var ref:QName = null;
         var attributeName:QName = null;
         var attributeFixed:String = null;
         var attributeValue:* = undefined;
         var attributeDefault:String = null;
         var typeDefinition:XML = null;
         var typeName:String = null;
         var attributeType:QName = null;
         var result:* = undefined;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.attributeQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve attribute definition for \'" + ref + "\'");
            }
         }
         var attributeNameString:String = definition.@name.toString();
         var attributeUse:String = definition.attribute("use").toString();
         if(attributeUse != "prohibited")
         {
            attributeName = schemaManager.getQNameForAttribute(attributeNameString,getAttributeFromNode("form",definition));
            attributeFixed = getAttributeFromNode("fixed",definition);
            if(attributeFixed != null)
            {
               value = attributeFixed;
            }
            else
            {
               value = this.getAttribute(value,attributeName);
               if(value === undefined)
               {
                  attributeDefault = getAttributeFromNode("default",definition);
                  if(attributeDefault != null)
                  {
                     value = attributeDefault;
                  }
               }
            }
            if(value !== undefined)
            {
               attributeValue = this.createContent();
               typeName = getAttributeFromNode("type",definition);
               if(typeName != null)
               {
                  attributeType = schemaManager.getQNameForPrefixedName(definition.@type,definition);
               }
               else
               {
                  attributeType = schemaManager.schemaDatatypes.anySimpleTypeQName;
               }
               if(attributeType != null)
               {
                  if(isBuiltInType(attributeType))
                  {
                     result = this.marshallBuiltInType(attributeType,attributeValue,attributeName,value,restriction);
                     this.setValue(attributeValue,attributeName,result);
                  }
                  else
                  {
                     typeDefinition = schemaManager.getNamedDefinition(attributeType,constants.simpleTypeQName);
                     if(typeDefinition == null)
                     {
                        throw new Error("Cannot find simpleType " + attributeType + " for attribute " + attributeName);
                     }
                     this.decodeSimpleType(typeDefinition,attributeValue,attributeName,value,restriction);
                     schemaManager.releaseScope();
                  }
               }
               else
               {
                  typeDefinition = getSingleElementFromNode(definition,constants.simpleTypeQName);
                  if(typeDefinition != null)
                  {
                     this.decodeSimpleType(typeDefinition,attributeValue,attributeName,value,restriction);
                  }
                  else if(value != null)
                  {
                     attributeValue = value;
                  }
               }
            }
            if(attributeValue != null)
            {
               this.setAttribute(parent,attributeName,attributeValue);
            }
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
      }
      
      public function decodeAttributeGroup(definition:XML, parent:*, value:* = undefined, restriction:XML = null) : void
      {
         var ref:QName = null;
         var attribute:XML = null;
         var attributeGroups:XMLList = null;
         var attributeGroup:XML = null;
         var anyAttribute:XML = null;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.attributeGroupQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve attributeGroup definition for \'" + ref + "\'");
            }
         }
         var attributes:XMLList = definition.elements(constants.attributeQName);
         for each(attribute in attributes)
         {
            this.decodeAttribute(attribute,parent,value,restriction);
         }
         attributeGroups = definition.elements(constants.attributeGroupQName);
         for each(attributeGroup in attributeGroups)
         {
            this.decodeAttributeGroup(attributeGroup,parent,value,restriction);
         }
         anyAttribute = getSingleElementFromNode(definition,constants.anyAttributeQName);
         if(anyAttribute != null)
         {
            this.decodeAnyAttribute(anyAttribute,parent,value,restriction);
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
      }
      
      public function decodeChoice(definition:XML, parent:*, name:QName, valueElements:XMLList, context:DecodingContext = null, isRequired:Boolean = true) : Boolean
      {
         var choiceSatisfied:Boolean = false;
         var lastIndex:uint = 0;
         var choiceOccurs:uint = 0;
         var childDefinition:XML = null;
         if(context == null)
         {
            context = new DecodingContext();
         }
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(maxOccurs == 0)
         {
            return false;
         }
         if(valueElements == null && minOccurs == 0)
         {
            return true;
         }
         var choiceElements:XMLList = definition.elements();
         if(choiceElements.length() == 0)
         {
            return true;
         }
         for(choiceOccurs = 0; choiceOccurs < maxOccurs; choiceOccurs++)
         {
            lastIndex = context.index + 0;
            choiceSatisfied = false;
            for each(childDefinition in choiceElements)
            {
               if(childDefinition.name() == constants.elementTypeQName)
               {
                  choiceSatisfied ||= this.decodeGroupElement(childDefinition,parent,valueElements,context,false);
                  if(context.index > lastIndex)
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.sequenceQName)
               {
                  choiceSatisfied ||= this.decodeSequence(childDefinition,parent,name,valueElements,context,false);
                  if(context.index > lastIndex)
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.groupQName)
               {
                  choiceSatisfied ||= this.decodeGroupReference(childDefinition,parent,name,valueElements,context,false);
                  if(context.index > lastIndex)
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.choiceQName)
               {
                  choiceSatisfied ||= this.decodeChoice(childDefinition,parent,name,valueElements,context,false);
                  if(context.index > lastIndex)
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.anyQName)
               {
                  choiceSatisfied ||= this.decodeAnyElement(childDefinition,parent,name,valueElements,context,false);
                  if(context.index > lastIndex)
                  {
                     break;
                  }
               }
            }
            if(!choiceSatisfied)
            {
               break;
            }
         }
         if(choiceOccurs < minOccurs)
         {
            if(isRequired && strictOccurenceBounds)
            {
               throw new Error("Value supplied for choice " + name.toString() + " occurs " + choiceOccurs + " times which falls short of minOccurs " + minOccurs + ".");
            }
            return false;
         }
         return true;
      }
      
      public function decodeComplexContent(definition:XML, parent:*, name:QName, value:*, context:DecodingContext) : void
      {
         var childDefinition:XML = getSingleElementFromNode(definition,constants.extensionQName,constants.restrictionQName);
         if(childDefinition.name() == constants.extensionQName)
         {
            this.decodeComplexExtension(childDefinition,parent,name,value,context);
         }
         else if(childDefinition.name() == constants.restrictionQName)
         {
            this.decodeComplexRestriction(childDefinition,parent,name,value);
         }
      }
      
      public function decodeComplexExtension(definition:XML, parent:*, name:QName, value:*, context:DecodingContext = null) : void
      {
         var childDefinition:XML = null;
         if(context == null)
         {
            context = new DecodingContext();
         }
         context.hasContextSiblings = true;
         var baseName:String = getAttributeFromNode("base",definition);
         if(baseName == null)
         {
            throw new Error("A complexContent extension must declare a base type.");
         }
         var baseType:QName = schemaManager.getQNameForPrefixedName(baseName,definition);
         var baseDefinition:XML = schemaManager.getNamedDefinition(baseType,constants.complexTypeQName);
         if(baseDefinition == null)
         {
            throw new Error("Cannot find base type definition \'" + baseType + "\'");
         }
         var originalLaxSequence:Boolean = context.laxSequence;
         context.laxSequence = true;
         this.decodeComplexType(baseDefinition,parent,name,value,null,context);
         schemaManager.releaseScope();
         var childElements:XMLList = definition.elements();
         var valueElements:XMLList = new XMLList();
         if(value is XML)
         {
            valueElements = (value as XML).elements();
         }
         else if(value is XMLList)
         {
            valueElements = value;
         }
         for each(childDefinition in childElements)
         {
            if(childDefinition.name() == constants.sequenceQName)
            {
               this.decodeSequence(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               this.decodeGroupReference(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.allQName)
            {
               this.decodeAll(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               this.decodeChoice(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.attributeQName)
            {
               this.decodeAttribute(childDefinition,parent,value);
            }
            else if(childDefinition.name() == constants.attributeGroupQName)
            {
               this.decodeAttributeGroup(childDefinition,parent,value);
            }
            else if(childDefinition.name() == constants.anyAttributeQName)
            {
               this.decodeAnyAttribute(childDefinition,parent,value);
            }
         }
         context.laxSequence = originalLaxSequence;
      }
      
      public function decodeComplexRestriction(restriction:XML, parent:*, name:QName, value:*) : void
      {
         var childDefinition:XML = null;
         var baseName:String = getAttributeFromNode("base",restriction);
         if(baseName == null)
         {
            throw new Error("A complexContent restriction must declare a base type.");
         }
         var baseType:QName = schemaManager.getQNameForPrefixedName(baseName,restriction);
         var childElements:XMLList = restriction.elements();
         var valueElements:XMLList = new XMLList();
         if(value is XML)
         {
            valueElements = (value as XML).elements();
         }
         else if(value is XMLList)
         {
            valueElements = value;
         }
         for each(childDefinition in childElements)
         {
            if(childDefinition.name() == constants.sequenceQName)
            {
               this.decodeSequence(childDefinition,parent,name,valueElements);
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               this.decodeGroupReference(childDefinition,parent,name,valueElements);
            }
            else if(childDefinition.name() == constants.allQName)
            {
               this.decodeAll(childDefinition,parent,name,valueElements);
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               this.decodeChoice(childDefinition,parent,name,valueElements);
            }
            else if(childDefinition.name() == constants.attributeQName)
            {
               this.decodeAttribute(childDefinition,parent,value);
            }
            else if(childDefinition.name() == constants.attributeGroupQName)
            {
               this.decodeAttributeGroup(childDefinition,parent,value);
            }
            else if(childDefinition.name() == constants.anyAttributeQName)
            {
               this.decodeAnyAttribute(childDefinition,parent,value);
            }
         }
      }
      
      public function decodeComplexType(definition:XML, parent:*, name:QName, value:*, restriction:XML = null, context:DecodingContext = null) : void
      {
         var childDefinition:XML = null;
         if(parent is ContentProxy)
         {
            ContentProxy(parent).object_proxy::isSimple = false;
         }
         var childElements:XMLList = definition.elements();
         var valueElements:XMLList = new XMLList();
         if(value is XML)
         {
            valueElements = (value as XML).elements();
         }
         else if(value is XMLList)
         {
            valueElements = value;
         }
         for each(childDefinition in childElements)
         {
            if(childDefinition.name() == constants.simpleContentQName)
            {
               this.decodeSimpleContent(childDefinition,parent,name,value,restriction);
            }
            else if(childDefinition.name() == constants.complexContentQName)
            {
               this.decodeComplexContent(childDefinition,parent,name,value,context);
            }
            else if(childDefinition.name() == constants.sequenceQName)
            {
               this.decodeSequence(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               this.decodeGroupReference(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.allQName)
            {
               this.decodeAll(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               this.decodeChoice(childDefinition,parent,name,valueElements,context);
            }
            else if(childDefinition.name() == constants.attributeQName)
            {
               this.decodeAttribute(childDefinition,parent,value,restriction);
            }
            else if(childDefinition.name() == constants.attributeGroupQName)
            {
               this.decodeAttributeGroup(childDefinition,parent,value,restriction);
            }
            else if(childDefinition.name() == constants.anyAttributeQName)
            {
               this.decodeAnyAttribute(childDefinition,parent,value,restriction);
            }
         }
      }
      
      public function decodeGroupElement(definition:XML, parent:*, valueElements:XMLList, context:DecodingContext = null, isRequired:Boolean = true, hasSiblings:Boolean = true) : Boolean
      {
         var ref:QName = null;
         var element:* = undefined;
         var typeAttribute:String = null;
         var typeQName:QName = null;
         var emptyArray:* = undefined;
         var elementOccurs:uint = 0;
         var item:XML = null;
         if(context == null)
         {
            context = new DecodingContext();
         }
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(maxOccurs == 0)
         {
            return true;
         }
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.elementTypeQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve element definition for ref \'" + ref + "\'");
            }
         }
         var elementName:String = definition.@name.toString();
         var elementQName:QName = schemaManager.getQNameForElement(elementName,getAttributeFromNode("form",definition));
         var applicableValues:XMLList = this.getApplicableValues(parent,valueElements,elementQName,context,maxOccurs);
         if(applicableValues.length() == 1 && this.isXSINil(applicableValues[0]))
         {
            this.setValue(parent,elementQName,null);
            ++context.index;
            if(ref != null)
            {
               schemaManager.releaseScope();
            }
            return true;
         }
         if(maxOccurs > 1)
         {
            typeAttribute = getAttributeFromNode("type",definition);
            if(typeAttribute != null)
            {
               typeQName = schemaManager.getQNameForPrefixedName(typeAttribute,definition);
            }
            emptyArray = this.createIterableValue(typeQName);
            if(hasSiblings)
            {
               this.setValue(parent,elementQName,emptyArray,typeQName);
            }
            else if(!(parent is ContentProxy && parent.object_proxy::content != undefined))
            {
               this.setValue(parent,null,emptyArray,typeQName);
            }
         }
         if(applicableValues.length() == 0)
         {
            if(ref != null)
            {
               schemaManager.releaseScope();
            }
            if(minOccurs == 0)
            {
               return true;
            }
            return false;
         }
         if(maxOccurs == 1)
         {
            element = this.decodeElementTopLevel(definition,elementQName,this.parseValue(elementQName,applicableValues));
            this.setValue(parent,elementQName,element);
            ++context.index;
         }
         else if(maxOccurs > 1)
         {
            if(applicableValues.length() < minOccurs)
            {
               if(ref != null)
               {
                  schemaManager.releaseScope();
               }
               if(strictOccurenceBounds)
               {
                  throw new Error("Value supplied for element \'" + elementQName + "\' occurs " + applicableValues.length() + " times which falls short of minOccurs " + minOccurs + ".");
               }
               return false;
            }
            if(applicableValues.length() > maxOccurs)
            {
               if(ref != null)
               {
                  schemaManager.releaseScope();
               }
               if(strictOccurenceBounds)
               {
                  throw new Error("Value supplied for element of type \'" + elementQName + "\' occurs " + applicableValues.length() + " times which exceeds maxOccurs " + maxOccurs + ".");
               }
               return false;
            }
            elementOccurs = 0;
            while(elementOccurs < maxOccurs && elementOccurs < applicableValues.length())
            {
               item = applicableValues[elementOccurs];
               element = this.decodeElementTopLevel(definition,elementQName,item);
               this.setValue(parent,elementQName,element);
               ++context.index;
               elementOccurs++;
            }
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
         return true;
      }
      
      public function decodeElementTopLevel(definition:XML, elementQName:QName, value:*) : *
      {
         var content:* = undefined;
         var processedElement:* = undefined;
         var typeQName:QName = null;
         var xsiType:QName = null;
         var typeDefinition:XML = null;
         var typeQName2:QName = null;
         var nillable:Boolean = definition.@nillable.toString() == "true" ? true : false;
         if(nillable && value == null)
         {
            return value;
         }
         var fixedValue:String = getAttributeFromNode("fixed",definition);
         if(fixedValue != null)
         {
            value = fixedValue;
         }
         var defaultValue:String = getAttributeFromNode("default",definition);
         if(!nillable && value == null)
         {
            value = defaultValue;
         }
         if(value == null)
         {
            return value;
         }
         var attributeValue:String = getAttributeFromNode("type",definition);
         if(attributeValue != null)
         {
            typeQName = schemaManager.getQNameForPrefixedName(attributeValue,definition);
            xsiType = this.getXSIType(value);
            if(xsiType != null)
            {
               typeQName = xsiType;
            }
            content = this.createContent(typeQName);
            this.decodeType(typeQName,content,elementQName,value);
            return content;
         }
         if(definition.hasComplexContent())
         {
            typeDefinition = getSingleElementFromNode(definition,constants.complexTypeQName,constants.simpleTypeQName);
            content = this.createContent();
            if(typeDefinition.name() == constants.complexTypeQName)
            {
               this.decodeComplexType(typeDefinition,content,elementQName,value);
            }
            else if(typeDefinition.name() == constants.simpleTypeQName)
            {
               this.decodeSimpleType(typeDefinition,content,elementQName,value);
            }
            return content;
         }
         if(fixedValue != null || defaultValue != null)
         {
            typeQName2 = schemaManager.schemaDatatypes.stringQName;
         }
         else
         {
            typeQName2 = constants.anyTypeQName;
         }
         content = this.createContent(typeQName2);
         this.decodeType(typeQName2,content,elementQName,value);
         return content;
      }
      
      public function decodeGroupReference(definition:XML, parent:*, name:QName, valueElements:XMLList, context:DecodingContext = null, isRequired:Boolean = true) : Boolean
      {
         var ref:QName = null;
         var childDefinition:XML = null;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.groupQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve group definition for \'" + ref + "\'");
            }
            var groupElements:XMLList = definition.elements();
            var groupSatisfied:Boolean = false;
            for each(childDefinition in groupElements)
            {
               if(childDefinition.name() == constants.allQName)
               {
                  groupSatisfied = this.decodeAll(childDefinition,parent,name,valueElements,context,isRequired);
               }
               else if(childDefinition.name() == constants.choiceQName)
               {
                  groupSatisfied = this.decodeChoice(childDefinition,parent,name,valueElements,context,isRequired);
               }
               else if(childDefinition.name() == constants.sequenceQName)
               {
                  groupSatisfied = this.decodeSequence(childDefinition,parent,name,valueElements,context,isRequired);
               }
            }
            schemaManager.releaseScope();
            return groupSatisfied;
         }
         throw new Error("A group reference element must have the ref attribute.");
      }
      
      public function decodeSequence(definition:XML, parent:*, name:QName, valueElements:XMLList, context:DecodingContext = null, isRequired:Boolean = true) : Boolean
      {
         var sequenceOccurs:uint = 0;
         var requireChild:Boolean = false;
         var sequenceSatisfied:Boolean = false;
         var lastIndex:uint = 0;
         var childDefinition:XML = null;
         if(context == null)
         {
            context = new DecodingContext();
         }
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(maxOccurs == 0)
         {
            return false;
         }
         if((valueElements == null || valueElements.length() == 0) && minOccurs == 0)
         {
            return true;
         }
         var sequenceElements:XMLList = definition.elements();
         var hasSiblings:Boolean = sequenceElements.length() > 1 || context.hasContextSiblings;
         if(sequenceElements.length() == 0)
         {
            return true;
         }
         for(sequenceOccurs = 0; sequenceOccurs < maxOccurs; sequenceOccurs++)
         {
            requireChild = isRequired && sequenceOccurs < minOccurs;
            sequenceSatisfied = true;
            lastIndex = context.index + 0;
            for each(childDefinition in sequenceElements)
            {
               sequenceSatisfied = false;
               if(childDefinition.name() == constants.annotationQName)
               {
                  sequenceSatisfied = true;
               }
               if(childDefinition.name() == constants.elementTypeQName)
               {
                  if(!this.decodeGroupElement(childDefinition,parent,valueElements,context,requireChild,hasSiblings))
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.groupQName)
               {
                  if(!this.decodeGroupReference(childDefinition,parent,name,valueElements,context,requireChild))
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.choiceQName)
               {
                  if(!this.decodeChoice(childDefinition,parent,name,valueElements,context,requireChild))
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.sequenceQName)
               {
                  if(!this.decodeSequence(childDefinition,parent,name,valueElements,context,requireChild))
                  {
                     break;
                  }
               }
               else if(childDefinition.name() == constants.anyQName)
               {
                  if(!this.decodeAnyElement(childDefinition,parent,name,valueElements,context,requireChild))
                  {
                     break;
                  }
               }
               sequenceSatisfied = true;
            }
            if(!sequenceSatisfied && requireChild)
            {
               if(strictOccurenceBounds)
               {
                  throw new Error("Cannot find value for definition " + childDefinition.toXMLString() + " in sequence.");
               }
               return false;
            }
            if(lastIndex == context.index)
            {
               if(sequenceSatisfied)
               {
                  sequenceOccurs++;
                  sequenceOccurs = sequenceOccurs > minOccurs ? sequenceOccurs : minOccurs;
               }
               break;
            }
         }
         if(sequenceOccurs < minOccurs)
         {
            if(isRequired && strictOccurenceBounds)
            {
               throw new Error("Value supplied for sequence " + name.toString() + " occurs " + sequenceOccurs + " times which falls short of minOccurs " + minOccurs + ".");
            }
            return false;
         }
         return true;
      }
      
      public function decodeSimpleContent(definition:XML, parent:*, name:QName, value:*, restriction:XML = null) : void
      {
         var baseName:String = null;
         var baseType:QName = null;
         var simpleValue:* = undefined;
         var baseDefinition:XML = null;
         var extensions:XMLList = null;
         var extensionChild:XML = null;
         var result:* = undefined;
         var childDefinition:XML = getSingleElementFromNode(definition,constants.extensionQName,constants.restrictionQName);
         if(parent is ContentProxy)
         {
            ContentProxy(parent).object_proxy::isSimple = true;
         }
         if(childDefinition != null)
         {
            baseName = getAttributeFromNode("base",childDefinition);
            if(baseName == null)
            {
               throw new Error("A simpleContent extension or restriction must declare a base type.");
            }
            baseType = schemaManager.getQNameForPrefixedName(baseName,childDefinition);
            if(!isBuiltInType(baseType))
            {
               baseDefinition = schemaManager.getNamedDefinition(baseType,constants.complexTypeQName,constants.simpleTypeQName);
               if(baseDefinition == null)
               {
                  throw new Error("Cannot find base type definition \'" + baseType + "\'");
               }
               schemaManager.releaseScope();
            }
            if(childDefinition.name() == constants.extensionQName)
            {
               if(isBuiltInType(baseType))
               {
                  simpleValue = this.getSimpleValue(value,name);
                  result = this.marshallBuiltInType(baseType,parent,name,simpleValue,restriction);
                  this.setSimpleValue(parent,name,result,baseType);
               }
               else
               {
                  this.decodeType(baseType,parent,name,value,restriction);
               }
               extensions = childDefinition.elements();
               for each(extensionChild in extensions)
               {
                  if(extensionChild.name() == constants.attributeQName)
                  {
                     this.decodeAttribute(extensionChild,parent,value,restriction);
                  }
                  else if(extensionChild.name() == constants.attributeGroupQName)
                  {
                     this.decodeAttributeGroup(extensionChild,parent,value,restriction);
                  }
                  else if(extensionChild.name() == constants.anyAttributeQName)
                  {
                     this.decodeAnyAttribute(extensionChild,parent,value,restriction);
                  }
               }
            }
            else if(childDefinition.name() == constants.restrictionQName)
            {
               simpleValue = this.getSimpleValue(value,name);
               this.decodeSimpleRestriction(childDefinition,parent,name,simpleValue);
            }
         }
      }
      
      public function decodeSimpleList(definition:XML, parent:*, name:QName, value:*, restriction:XML = null) : void
      {
         var itemTypeQName:QName = null;
         var itemDefinition:XML = null;
         var item:* = undefined;
         var tempValue:* = undefined;
         var encodedItem:String = null;
         var itemTypeAttribute:String = definition.@itemType;
         if(itemTypeAttribute != "")
         {
            itemTypeQName = schemaManager.getQNameForPrefixedName(itemTypeAttribute,definition);
         }
         else
         {
            itemDefinition = getSingleElementFromNode(definition,constants.simpleTypeQName);
         }
         var listValue:String = "";
         if(!TypeIterator.isIterable(value))
         {
            value = [value];
         }
         var iter:TypeIterator = new TypeIterator(value);
         while(iter.hasNext())
         {
            item = iter.next();
            tempValue = this.createContent();
            if(itemTypeQName != null)
            {
               this.decodeType(itemTypeQName,tempValue,name,item,restriction);
            }
            else
            {
               this.decodeSimpleType(itemDefinition,tempValue,name,item,restriction);
            }
            encodedItem = tempValue != null ? tempValue.toString() : "";
            listValue = listValue.concat(encodedItem);
            if(iter.hasNext())
            {
               listValue = listValue.concat(" ");
            }
         }
         this.setValue(parent,name,listValue,itemTypeQName);
      }
      
      public function decodeSimpleRestriction(restriction:XML, parent:*, name:QName, value:*) : void
      {
         var baseName:String = null;
         var baseType:QName = null;
         var simpleTypeDefinition:XML = getSingleElementFromNode(restriction,constants.simpleTypeQName);
         if(simpleTypeDefinition != null)
         {
            this.decodeSimpleType(simpleTypeDefinition,parent,name,value,restriction);
         }
         else
         {
            baseName = getAttributeFromNode("base",restriction);
            baseType = schemaManager.getQNameForPrefixedName(baseName,restriction);
            this.decodeType(baseType,parent,name,value,restriction);
         }
      }
      
      public function decodeSimpleType(definition:XML, parent:*, name:QName, value:*, restriction:XML = null) : void
      {
         var definitionChild:XML = getSingleElementFromNode(definition,constants.restrictionQName,constants.listQName,constants.unionQName);
         if(definitionChild.name() == constants.restrictionQName)
         {
            this.decodeSimpleRestriction(definitionChild,parent,name,value);
         }
         else if(definitionChild.name() == constants.listQName)
         {
            this.decodeSimpleList(definitionChild,parent,name,value,restriction);
         }
         else if(definitionChild.name() == constants.listQName)
         {
            this.decodeSimpleUnion(definitionChild,parent,name,value,restriction);
         }
      }
      
      public function decodeSimpleUnion(definition:XML, parent:*, name:QName, value:*, restriction:XML = null) : void
      {
         var type:QName = null;
         var args:* = undefined;
         var prefixedName:String = null;
         var simpleType:QName = null;
         var memberList:String = getAttributeFromNode("memberTypes",definition);
         var memberArray:Array = memberList.split(" ");
         for(var i:int = 0; i < memberArray.length; i++)
         {
            prefixedName = memberArray[i];
            simpleType = schemaManager.getQNameForPrefixedName(prefixedName,definition);
            if(!isBuiltInType(simpleType))
            {
               args = this.getValue(value,simpleType);
               if(args !== undefined)
               {
                  type = simpleType;
                  break;
               }
            }
         }
         if(!type)
         {
            type = schemaManager.schemaDatatypes.stringQName;
         }
         var result:* = this.marshallBuiltInType(type,parent,name,value,restriction);
         this.setValue(parent,name,result,type);
      }
      
      public function decodeType(type:QName, parent:*, name:QName, value:*, restriction:XML = null) : void
      {
         var result:* = undefined;
         var definition:XML = null;
         var definitionType:QName = null;
         if(isBuiltInType(type))
         {
            result = this.marshallBuiltInType(type,parent,name,value,restriction);
            this.setValue(parent,name,result,type);
         }
         else
         {
            definition = schemaManager.getNamedDefinition(type,constants.complexTypeQName,constants.simpleTypeQName);
            if(definition == null)
            {
               throw new Error("Cannot find definition for type \'" + type + "\'");
            }
            if(this.isXSINil(value))
            {
               this.setValue(parent,name,null,type);
               return;
            }
            definitionType = definition.name() as QName;
            if(definitionType == constants.complexTypeQName)
            {
               this.decodeComplexType(definition,parent,name,value,restriction);
            }
            else
            {
               if(definitionType != constants.simpleTypeQName)
               {
                  throw new Error("Invalid type definition " + definitionType);
               }
               this.decodeSimpleType(definition,parent,name,value,restriction);
            }
            schemaManager.releaseScope();
         }
         this.setXSIType(parent,type);
      }
      
      public function marshallBuiltInType(type:QName, parent:*, name:QName, value:*, restriction:XML = null) : *
      {
         var propertyList:XMLList = null;
         var content:* = undefined;
         var xml:XML = null;
         var nilAttribute:String = null;
         if(type == constants.anyTypeQName && !this.isSimpleValue(value))
         {
            if(value is XML)
            {
               xml = XML(value);
               if(xml.nodeKind() == "element")
               {
                  nilAttribute = xml.attribute(constants.nilQName).toString();
                  if(nilAttribute == "true")
                  {
                     return null;
                  }
               }
               if(xml.hasSimpleContent())
               {
                  content = new SimpleContent(xml.text().toString());
                  propertyList = this.filterAttributes(xml.attributes());
                  if(propertyList.length() == 0)
                  {
                     return schemaManager.unmarshall(xml,type,restriction);
                  }
               }
               else
               {
                  content = this.createContent();
                  if(content is ContentProxy)
                  {
                     ContentProxy(content).object_proxy::isSimple = false;
                  }
                  propertyList = xml.elements();
                  propertyList += this.filterAttributes(xml.attributes());
               }
            }
            else
            {
               content = this.createContent();
               if(content is ContentProxy)
               {
                  ContentProxy(content).object_proxy::isSimple = false;
               }
               propertyList = new XMLList(value);
            }
            this.decodeAnyType(content,name,propertyList);
            return content;
         }
         return schemaManager.unmarshall(value,type,restriction);
      }
      
      override public function reset() : void
      {
         super.reset();
         this.document = null;
      }
      
      public function getAttribute(parent:*, name:*) : *
      {
         var result:* = undefined;
         var attribute:XMLList = null;
         if(parent is XML)
         {
            attribute = XML(parent).attribute(name);
            result = this.parseValue(name,attribute);
         }
         else if(parent is XMLList)
         {
            attribute = XMLList(parent).attribute(name);
            result = this.parseValue(name,attribute);
         }
         return result;
      }
      
      public function hasAttribute(parent:*, name:*) : Boolean
      {
         return this.getAttribute(parent,name) !== undefined;
      }
      
      public function setAttribute(parent:*, name:*, value:*) : void
      {
         var parentProxy:ContentProxy = null;
         var existingContent:* = undefined;
         var simpleContent:SimpleContent = null;
         if(parent is ContentProxy)
         {
            parentProxy = parent as ContentProxy;
            if(parentProxy.object_proxy::isSimple)
            {
               existingContent = parentProxy.object_proxy::content;
               if(!(existingContent is SimpleContent))
               {
                  simpleContent = new SimpleContent(existingContent);
                  parentProxy.object_proxy::content = simpleContent;
               }
               parentProxy.object_proxy::isSimple = false;
            }
         }
         this.setValue(parent,name,value);
      }
      
      public function getProperties(value:*) : Array
      {
         var elements:XMLList = null;
         var element:XML = null;
         var properties:Array = [];
         if(value is XML)
         {
            elements = XML(value).elements();
         }
         else if(value is XMLList)
         {
            elements = XMLList(value).elements();
         }
         if(elements != null)
         {
            for each(element in elements)
            {
               properties.push(element.name());
            }
         }
         return properties;
      }
      
      public function createContent(type:QName = null) : *
      {
         var c:Class = null;
         var className:String = null;
         var content:* = undefined;
         if(type != null && this.typeRegistry != null)
         {
            c = this.typeRegistry.getClass(type);
            if(c == null)
            {
               c = this.typeRegistry.getCollectionClass(type);
            }
            if(c != null)
            {
               try
               {
                  content = new c();
               }
               catch(e:Error)
               {
                  className = getQualifiedClassName(c);
                  log.debug("Unable to create new instance of Class \'{0}\' for type \'{1}\'.",className,type);
               }
            }
         }
         return new ContentProxy(content,this.makeObjectsBindable);
      }
      
      public function isSimpleValue(value:*) : Boolean
      {
         var xml:XML = null;
         var attributes:XMLList = null;
         if(value is XML)
         {
            xml = XML(value);
            attributes = xml.attributes();
            if(attributes != null && attributes.length() > 0)
            {
               return false;
            }
            return xml.hasSimpleContent();
         }
         if(value is String || value is Number || value is Boolean || value is Date || value is int || value is uint || value is ByteArray)
         {
            return true;
         }
         return false;
      }
      
      public function getSimpleValue(parent:*, name:*) : *
      {
         var xml:XML = null;
         var list:XMLList = null;
         if(parent is XML)
         {
            xml = parent as XML;
            if(xml.hasSimpleContent())
            {
               return xml.toString();
            }
         }
         else if(parent is XMLList)
         {
            list = parent as XMLList;
            if(list.hasSimpleContent())
            {
               return list.toString();
            }
         }
         else if(this.isSimpleValue(parent))
         {
            return parent;
         }
         return this.getValue(parent,name);
      }
      
      public function setSimpleValue(parent:*, name:*, value:*, type:Object = null) : void
      {
         var parentProxy:ContentProxy = null;
         if(parent is ContentProxy)
         {
            parentProxy = parent as ContentProxy;
            if(parentProxy.object_proxy::isSimple)
            {
               parentProxy.object_proxy::content = value;
               return;
            }
         }
         this.setValue(parent,name,value,type);
      }
      
      public function getValue(parent:*, name:*, index:Number = -1) : *
      {
         var result:* = undefined;
         var qname:QName = null;
         var elements:XMLList = null;
         if(name is QName)
         {
            qname = name as QName;
            if(qname.uri == null || qname.uri == "")
            {
               name = qname.localName;
            }
         }
         if(parent is XML)
         {
            elements = XML(parent).elements(name);
            if(elements.length() > 0)
            {
               result = this.parseValue(name,elements);
            }
         }
         else if(parent is XMLList)
         {
            elements = XMLList(parent).elements(name);
            if(elements.length() > 0)
            {
               result = this.parseValue(name,elements);
            }
         }
         else if(parent is ContentProxy)
         {
            if(qname != null)
            {
               name = qname.localName;
            }
            result = (parent as ContentProxy).hasOwnProperty(name) ? parent[name] : undefined;
         }
         else if(!this.isSimpleValue(parent))
         {
            result = parent[name];
         }
         return result;
      }
      
      public function hasValue(parent:*, name:*) : Boolean
      {
         return this.getValue(parent,name) !== undefined;
      }
      
      public function setValue(parent:*, name:*, value:*, type:Object = null) : void
      {
         var existingValue:* = undefined;
         var propertyName:String = null;
         var simpleContent:* = undefined;
         var localName:String = null;
         var simplePropName:String = null;
         var proxyParent:ContentProxy = null;
         if(parent != null)
         {
            if(value is ContentProxy)
            {
               value = ContentProxy(value).object_proxy::content;
            }
            if(TypeIterator.isIterable(parent))
            {
               TypeIterator.push(parent,value);
            }
            else if(name != null)
            {
               if(name is ContentProxy)
               {
                  name = ContentProxy(name).object_proxy::content;
               }
               if(name is QName)
               {
                  propertyName = QName(name).localName;
               }
               else
               {
                  propertyName = Object(name).toString();
               }
               if(parent is ContentProxy && ContentProxy(parent).object_proxy::isSimple)
               {
                  simpleContent = ContentProxy(parent).object_proxy::content;
                  if(simpleContent != null)
                  {
                     if(this.isSimpleValue(simpleContent) || TypeIterator.isIterable(simpleContent))
                     {
                        existingValue = simpleContent;
                     }
                     else
                     {
                        localName = getUnqualifiedClassName(simpleContent);
                        simplePropName = "_" + localName;
                        if(Object(simpleContent).hasOwnProperty(simplePropName))
                        {
                           simpleContent[simplePropName] = value;
                           return;
                        }
                        simplePropName = localName.charAt(0).toLowerCase() + localName.substr(1);
                        if(Object(simpleContent).hasOwnProperty(simplePropName))
                        {
                           simpleContent[simplePropName] = value;
                           return;
                        }
                     }
                  }
               }
               else if(Object(parent).hasOwnProperty(propertyName))
               {
                  existingValue = this.getExistingValue(parent,propertyName);
               }
               else if(Object(parent).hasOwnProperty("_" + propertyName))
               {
                  existingValue = this.getExistingValue(parent,"_" + propertyName);
               }
               if(existingValue != null)
               {
                  existingValue = this.promoteValueToArray(existingValue,type);
                  TypeIterator.push(existingValue,value);
                  value = existingValue;
               }
               try
               {
                  if(parent is ContentProxy && ContentProxy(parent).object_proxy::isSimple)
                  {
                     ContentProxy(parent).object_proxy::content = value;
                  }
                  else
                  {
                     try
                     {
                        parent[propertyName] = value;
                     }
                     catch(e:Error)
                     {
                        parent["_" + propertyName] = value;
                     }
                  }
               }
               catch(e:Error)
               {
                  log.warn("Unable to set property \'{0}\' on parent.",propertyName);
               }
            }
            else if(parent is ContentProxy)
            {
               proxyParent = parent as ContentProxy;
               existingValue = proxyParent.object_proxy::content;
               if(existingValue !== undefined)
               {
                  existingValue = this.promoteValueToArray(existingValue,type);
                  proxyParent.object_proxy::content = existingValue;
                  TypeIterator.push(existingValue,value);
                  value = existingValue;
               }
               proxyParent.object_proxy::content = value;
            }
         }
      }
      
      public function createIterableValue(type:Object = null) : *
      {
         var value:* = undefined;
         var c:Class = null;
         try
         {
            if(type != null)
            {
               c = this.typeRegistry.getCollectionClass(type);
               if(c != null)
               {
                  value = new c();
               }
            }
         }
         catch(e1:Error)
         {
            log.debug("Error while resolving custom collection type for \'{0}\'.\nError: \'{1}\'.",type,e1);
         }
         try
         {
            if(value == null)
            {
               if(this.makeObjectsBindable)
               {
                  value = new listClass();
               }
               else
               {
                  value = [];
               }
            }
         }
         catch(e2:Error)
         {
            log.warn("Unable to create instance of \'{0}\'.",listClass);
         }
         return value;
      }
      
      protected function getApplicableValues(parent:*, valueElements:XMLList, name:QName, context:DecodingContext, maxOccurs:uint) : XMLList
      {
         var applicableValues:XMLList = new XMLList();
         var startIndex:uint = uint(context.index);
         var skipAhead:Boolean = false;
         if(context.anyIndex > -1 && name != null)
         {
            startIndex = uint(context.anyIndex);
            skipAhead = true;
         }
         else if(context.laxSequence)
         {
            startIndex = 0;
            skipAhead = true;
         }
         for(var i:uint = startIndex; i < valueElements.length(); i++)
         {
            if(applicableValues.length() == maxOccurs)
            {
               break;
            }
            if(name == null || valueElements[i].name() == name || (name.uri == "" || name.uri == null) && name.localName == valueElements[i].name().localName)
            {
               applicableValues += valueElements[i];
               if(i < context.index)
               {
                  parent[name.localName] = null;
               }
               skipAhead = false;
            }
            else if(skipAhead == false)
            {
               break;
            }
         }
         return applicableValues;
      }
      
      protected function includeNamespace(namespaceURI:String, includedNamespaces:Array = null) : Boolean
      {
         var matchFound:Boolean = false;
         var definedURI:String = null;
         if(includedNamespaces != null)
         {
            matchFound = false;
            for each(definedURI in includedNamespaces)
            {
               if(definedURI == "##local" && namespaceURI == null)
               {
                  return true;
               }
               if(URLUtil.urisEqual(namespaceURI,definedURI))
               {
                  return true;
               }
            }
            return false;
         }
         return true;
      }
      
      protected function parseValue(name:*, value:XMLList) : *
      {
         var result:* = value;
         if(value.hasSimpleContent())
         {
            if(this.isXSINil(value))
            {
               result = null;
            }
            else
            {
               result = value.toString();
            }
         }
         else if(value.length() == 1)
         {
            result = value[0];
         }
         return result;
      }
      
      protected function isXSINil(value:*) : Boolean
      {
         var nilAttribute:String = null;
         if(value != null)
         {
            nilAttribute = "false";
            if(value is XML)
            {
               nilAttribute = XML(value).attribute(constants.nilQName).toString();
            }
            else if(value is XMLList)
            {
               nilAttribute = XMLList(value).attribute(constants.nilQName).toString();
            }
            if(nilAttribute == "true")
            {
               return true;
            }
         }
         return false;
      }
      
      protected function promoteValueToArray(value:*, type:Object = null) : *
      {
         var array:* = undefined;
         if(!TypeIterator.isIterable(value))
         {
            array = this.createIterableValue(type);
            TypeIterator.push(array,value);
            value = array;
         }
         return value;
      }
      
      protected function getXSIType(value:*) : QName
      {
         var xsiType:QName = null;
         var xml:XML = null;
         var xsi:String = null;
         if(value is XML)
         {
            xml = value as XML;
         }
         else if(value is XMLList && value.length() == 1)
         {
            xml = value[0];
         }
         if(xml != null)
         {
            xsi = XMLUtil.getAttributeByQName(xml,constants.typeAttrQName).toString();
            if(xsi != null && xsi != "")
            {
               xsiType = schemaManager.getQNameForPrefixedName(xsi,xml);
            }
         }
         return xsiType;
      }
      
      protected function setXSIType(value:*, type:QName) : void
      {
         if(value != null && this.recordXSIType)
         {
            if(value is ContentProxy)
            {
               value = value.object_proxy::content;
            }
            if(value != null)
            {
               if(value is ObjectProxy)
               {
                  ObjectProxy(value).object_proxy::type = type;
               }
               else if(value is IXMLSchemaInstance)
               {
                  IXMLSchemaInstance(value).xsiType = type;
               }
            }
         }
      }
      
      protected function getExistingValue(parent:*, propertyName:String) : *
      {
         var className:String;
         var existingValue:* = undefined;
         var classInfo:XML = null;
         var properties:XMLList = null;
         var property:XML = null;
         var propertyType:String = null;
         var tempValue:* = undefined;
         var object:Object = Object(parent);
         if(parent is ContentProxy)
         {
            object = ContentProxy(parent).object_proxy::content;
         }
         if(object is ObjectProxy)
         {
            object = ObjectProxy(object).object_proxy::object;
         }
         className = getQualifiedClassName(object);
         if(className == "Object")
         {
            existingValue = parent[propertyName];
         }
         else
         {
            classInfo = DescribeTypeCache.describeType(object).typeDescription;
            properties = classInfo..accessor.(@access == "readwrite" && @name == propertyName) + classInfo..variable.(@name == propertyName);
            if(properties.length() > 0)
            {
               property = properties[0];
               propertyType = property.@type;
               tempValue = parent[propertyName];
               if(propertyType == "Object" || propertyType == "*" || TypeIterator.isIterable(tempValue))
               {
                  existingValue = tempValue;
               }
            }
         }
         return existingValue;
      }
      
      protected function filterAttributes(attributes:XMLList) : XMLList
      {
         var attr:XML = null;
         var name:QName = null;
         var filtered:XMLList = attributes.copy();
         for(var i:int = filtered.length() - 1; i >= 0; i--)
         {
            attr = filtered[i];
            if(attr != null)
            {
               name = attr.name();
               if(this.isInternalNamespace(name))
               {
                  delete filtered[i];
               }
            }
         }
         return filtered;
      }
      
      protected function isInternalNamespace(name:QName) : Boolean
      {
         var uri:String = name != null ? name.uri : null;
         if(Boolean(uri))
         {
            if(URLUtil.urisEqual(uri,constants.xsiNamespace.uri) || URLUtil.urisEqual(uri,constants.xsdNamespace.uri))
            {
               return true;
            }
         }
         return false;
      }
      
      protected function preProcessXML(root:XML) : void
      {
      }
   }
}

