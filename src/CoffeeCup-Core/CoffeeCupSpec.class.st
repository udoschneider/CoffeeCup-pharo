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

	stream nextPutAll: '# '.
	self url
		ifNotNil: [ 
			stream
				nextPut: $[;
				nextPutAll: self title;
				nextPutAll: '](';
				nextPutAll: self url;
				nextPut: $);
				cr;
				cr ]
		ifNil: [ 
			stream
				nextPutAll: self title;
				cr;
				cr ].
	self description ifNotNil: [ :value | 
		stream
			nextPutAll: value;
			cr;
			cr ].
		stream nextPutAll: 'Path: `'; nextPutAll: path;nextPutAll: '`';cr;cr.
	queryParameters notEmpty ifTrue: [ 
		stream
			nextPutAll: 'Query Parameters';
			cr.
		queryParameters do: [ :each | 
			stream nextPutAll: '* '.
			each documentationOn: stream.
			stream cr ].
		stream cr ].
	pathParameters notEmpty ifTrue: [ 
		stream
			nextPutAll: 'Path Parameters';
			cr.
		pathParameters do: [ :each | 
			stream nextPutAll: '* '.
			each documentationOn: stream.
			stream cr ].
		stream cr ].

	(self children sorted: [ :x :y | x name < y name ]) do: [ :each | 
		each documentationOn: stream ]
]

{ #category : #'as yet unclassified' }
CoffeeCupSpec >> documentationString [

	^ String streamContents: [ :stream | self documentationOn: stream ]
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

{ #category : #accessing }
CoffeeCupSpec >> url [

	^ self propertyAt: #url default: nil
]

{ #category : #accessing }
CoffeeCupSpec >> url: aString [

	^ self propertyAt: #url put: aString
]
