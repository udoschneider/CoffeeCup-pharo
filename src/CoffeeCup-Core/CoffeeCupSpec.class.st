Class {
	#name : #CoffeeCupSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'path',
		'pathParameters',
		'queryParameters',
		'properties'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #visiting }
CoffeeCupSpec >> acceptVisitor: aVisitor [

	^ aVisitor visitEndpoint: self
]

{ #category : #'double dispatch' }
CoffeeCupSpec >> appendTo: aRequest with: arguments [

	self subclassResponsibility
]

{ #category : #documentation }
CoffeeCupSpec >> description [

	^ self propertyAt: #description default: nil
]

{ #category : #accessing }
CoffeeCupSpec >> description: aString [

	^ self propertyAt: #description put: aString
]

{ #category : #'instance creation' }
CoffeeCupSpec >> do: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

{ #category : #'as yet unclassified' }
CoffeeCupSpec >> documentationOn: stream [

	(CoffeeCupDocumentationBuilder on: stream) visit: self
]

{ #category : #'as yet unclassified' }
CoffeeCupSpec >> documentationString [

	^ String streamContents: [ :stream | self documentationOn: stream ]
]

{ #category : #accessing }
CoffeeCupSpec >> fullPath [

	self subclassResponsibility
]

{ #category : #documentation }
CoffeeCupSpec >> href [

	^ self propertyAt: #href default: nil
]

{ #category : #initialization }
CoffeeCupSpec >> initialize [

	super initialize.
	pathParameters := Dictionary new.
	queryParameters := Dictionary new.
	properties := Dictionary new.
]

{ #category : #'as yet unclassified' }
CoffeeCupSpec >> inspectionDocumentation [

	<inspectorPresentationOrder: 10000 title: 'Documentation'>
	^ SpTextPresenter new
		  text: self documentationString;
		  yourself
]

{ #category : #accessing }
CoffeeCupSpec >> name [

	^ name
]

{ #category : #accessing }
CoffeeCupSpec >> parameter: aSymbolOrString [

	| key |
	key := aSymbolOrString asCoffeeCupSelector.

	^ pathParameters at: key ifAbsent: [ 
		  queryParameters
			  at: key
			  ifAbsentPut:[ (CoffeeCupQueryParameter key: key name: aSymbolOrString) ]]
]

{ #category : #configuration }
CoffeeCupSpec >> parameter: aSymbolOrString do: aBlock [

	^ (self parameter: aSymbolOrString) do: aBlock
]

{ #category : #accessing }
CoffeeCupSpec >> path [

	^ path ifNil: [ name asString ]
]

{ #category : #configuration }
CoffeeCupSpec >> path: aString [

	path := aString.

	pathParameters := Dictionary new.

	path coffeeCupFormatParameters do: [ :pathParameter | 
		| key |
		key := pathParameter asCoffeeCupSelector.
		pathParameters
			at: key
			put: (CoffeeCupPathParameter key: key name: pathParameter) ]
]

{ #category : #accessing }
CoffeeCupSpec >> pathParameterAt: key [

	^ pathParameters  at: key
]

{ #category : #accessing }
CoffeeCupSpec >> pathParameters [

	^ pathParameters
]

{ #category : #accessing }
CoffeeCupSpec >> propertyAt: aKey default: aValue [

	^ properties at: aKey ifAbsent: [ aValue ]
]

{ #category : #accessing }
CoffeeCupSpec >> propertyAt: aKey put: aValue [

	^ properties at: aKey put: aValue
]

{ #category : #accessing }
CoffeeCupSpec >> queryParameterAt: key [

	^ queryParameters at: key
]

{ #category : #accessing }
CoffeeCupSpec >> queryParameters [

	^ queryParameters
]

{ #category : #'instance creation' }
CoffeeCupSpec >> reference: aString [

	^ self propertyAt: #reference put: aString
]

{ #category : #accessing }
CoffeeCupSpec >> request: request [

	self subclassResponsibility 
]

{ #category : #documentation }
CoffeeCupSpec >> title [

	^ self propertyAt: #title default: nil
]

{ #category : #accessing }
CoffeeCupSpec >> title: aString [

	^ self propertyAt: #title put: aString
]
