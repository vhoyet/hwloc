function start(svgObject){
	makeDraggable(svgObject)

	const texts = svgObject.getElementsByTagName('text')
    for (let text of texts) {
    	text.setAttribute("style", text.getAttribute("style") + ";pointer-events:none;")
    }

	const elements = svgObject.getElementsByTagName('rect')
    for (let element of elements) {
    	if(!element.id.includes("Bridge")){
    		element.addEventListener('click', function(e) {
    			changeColor(svgObject, e.target)
			    changeText(svgObject, e.target)
			})
    	}	    	
	}
}

function changeColor(svgObject, element){
    oldColor = element.getAttribute("saveColor")

    if(!oldColor){
    	element.setAttribute("saveColor", element.getAttribute("fill"))
		element.setAttribute("fill", "red")
    }else{
    	element.setAttribute("fill", oldColor)
    	element.removeAttribute("saveColor")
    }
}

function changeText(svgObject, element){
	const text = getText(svgObject, element.id)

	let textContent = element.getAttribute("saveText")

	if(!textContent){
		element.setAttribute("saveText", text.innerHTML)
		textContent = element.getAttribute("width") > 90 ? "id : " + text.id : text.id.slice(-0,-5) + ".."
	}else{
		element.removeAttribute("saveText")
	}

	let svg   = svgObject.documentElement;
	let svgNS = svg.namespaceURI;
	let newText = text.cloneNode(false)

	newText.appendChild(svgObject.createTextNode(textContent))
	svg.removeChild(text)
	svg.appendChild(newText)
}

function getText(svgObject, id){
	let textId = id.replace('rect', 'text')
	const text = svgObject.getElementById(textId)

	return text
}

function makeDraggable(svgObject) {
	let selectedElement = null
	let text = null
	let marginTextX = null
	let marginTextY = null
	svgObject.addEventListener('mousedown', startDrag)
	svgObject.addEventListener('mousemove', drag)
	svgObject.addEventListener('mouseup', endDrag)
	svgObject.addEventListener('mouseleave', endDrag)

	function startDrag(evt) {
	  if (evt.target.classList.contains('draggable')) {
	    selectedElement = evt.target;
	    text = getText(svgObject, selectedElement.id)
	    marginTextX = text.getAttribute("x") - selectedElement.getAttribute("x")
	    marginTextY = text.getAttribute("y") - selectedElement.getAttribute("y")
	  }
	}

	function drag(evt) {
		if (selectedElement) {
			evt.preventDefault();
			let textDragX = evt.clientX + marginTextX
			let textDragY = evt.clientY + marginTextY
			let dragX = evt.clientX;
			let dragY = evt.clientY;

			selectedElement.setAttribute("x", dragX);
			selectedElement.setAttribute("y", dragY);
			text.setAttribute("x", textDragX);
			text.setAttribute("y", textDragY);
		}
	}

	function endDrag(evt) {
		selectedElement = null
	}
}





