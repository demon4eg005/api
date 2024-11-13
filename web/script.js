const productsTable = document.querySelector("#products-table") 
const filterCombobox = document.querySelector("#filter-combobox")
const searchInput = document.querySelector(".search-input")
const sortCombobox = document.querySelector("#sort-combobox")
const historyButton = document.querySelector("#historyButton")
const editButton = document.querySelector("#editButton")

const productForm = document.querySelector("#addForm")
const formContainer = document.getElementById('historyForm');
const productsHistoryTableBody = document.querySelector("#productsHistoryTable")

let fromtableproductid

let productsArray
let manufacturersArray
let productsSalesArray

searchInput.addEventListener("input", searchEventHandler)
filterCombobox.addEventListener("change", searchEventHandler)
sortCombobox.addEventListener("change", searchEventHandler)
productForm.addEventListener("submit", handleProductFormSubmit)
historyButton.addEventListener('click', function() {
    if(fromtableproductid == null) {
        alert("Сначала выберите товар")
        return
    }
    console.log("click")
    if (formContainer.style.display = 'none') {
        formContainer.style.display = 'block'; 
    } else {
        formContainer.style.display = 'none'; 
    }
    historyButton.disabled = true
    renderAllProductsHistory(productsSalesArray)
});
const closeFormBtn = document.getElementById('closeFormBtn');
    closeFormBtn.addEventListener('click', function() {
    const form = document.getElementById('historyFormid');
    historyButton.disabled = false
    formContainer.style.display = 'none'; 
    });

editButton.addEventListener("click", () => {
    if(fromtableproductid == null) {
        alert("Выберите товар для изменения")
        return
    }
    openForm()
    let currentProductID
    const idInput = document.querySelector('input[name="ID"]')
    const titleInput = document.querySelector('input[name="title"]')
    const costInput = document.querySelector('input[name="cost"]')
    const manufacturerSelect = document.querySelector('select[name="manufacturer"]')
    const isActiveSelect = document.querySelector('select[name="isactive"]')
    const descriptionTextarea = document.querySelector('textarea[name="description"]')
    const deleteButton = document.querySelector('button[class="button delete"]')
    deleteButton.setAttribute("edit", "true")
    productsArray.forEach(product => {
        if(product.id == fromtableproductid){
            currentProductID = product.id
            console.log(product)
            idInput.value = product.id
            titleInput.value = product.title
            costInput.value = product.cost
            manufacturerSelect.value = product.Manufacturer.name
            if(product.isactive) {
                isActiveSelect.value = 1
            }
            else{
                isActiveSelect.value = 0
            }
            
            descriptionTextarea.value = product.description
        }
    })
    deleteButton.addEventListener("click", async () => {
        question = confirm("Вы действительно хотите удалить этот продукт? (так же будут задета история продажи этого товара)")
        if(question) {
            const response = await fetch('http://localhost:3000/delete-product', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({id: currentProductID})
            })
            console.log("я тут")
            initialize()
            
            closeForm()
        }
    })
    fromtableproductid = null

})


async function handleProductFormSubmit(event) {
    event.preventDefault()
    const manufacturerList = document.querySelector('select[name="manufacturer"]')
    const selectedOption = manufacturerList.options[manufacturerList.selectedIndex]
    if(event.target.ID.value == "") {
        const productObj = {
            title: event.target.title.value,
            cost: event.target.cost.value,
            description: event.target.description.value,
            manufacturerId: selectedOption.dataset.id,
            isActive: event.target.isactive.value,
        }
    
        console.log(productObj)
    
        try {
            const response = await fetch('http://localhost:3000/post-product', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(productObj)
            })
            
            if (!response.ok) {
                throw new Error(`Ошибка HTTP: ${response.status}`)
            }
            
            const result = await response.json()
            console.log("Ответ сервера:", result)
            
            await initialize()
            
            closeForm()
            
        } catch (error) {
            console.error("Ошибка при отправке продукта:", error)
        }
    }
    else{
        const productObj = {
            id: event.target.ID.value,
            title: event.target.title.value,
            cost: event.target.cost.value,
            description: event.target.description.value,
            manufacturerId: selectedOption.dataset.id,
            isActive: event.target.isactive.value,
        }
    
        console.log(productObj)
    
        try {
            const response = await fetch('http://localhost:3000/put-product', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(productObj)
            })
            
            if (!response.ok) {
                throw new Error(`Ошибка HTTP: ${response.status}`)
            }
            
            const result = await response.json()
            console.log("Ответ сервера:", result)
            
            await initialize()
            
            closeForm()
            
        } catch (error) {
            console.error("Ошибка при отправке продукта:", error)
        }

    }
    
}
function openForm() {
    document.getElementById("addForm").style.display = "block"
    const manufacturerList = document.querySelector('select[name="manufacturer"]') 
    const deleteButton = document.querySelector('button[class="button delete"]')
    deleteButton.setAttribute("edit", "false")
    renderAllManufacturers(manufacturersArray, manufacturerList)
}
function closeForm() {
    document.getElementById("addForm").style.display = "none"
}
async function searchEventHandler() {
    const productsData = await getAllProducts()
    let _productsData = []
    
    const searchTerm = searchInput.value.toLowerCase()
    console.log(`SeachTerm: "${searchTerm}" filter: ${filterCombobox.value}`)
    if(searchInput.value == "" && filterCombobox.value == "0") {
        _productsData = productsData
    }
    else if(searchInput.value == "" && filterCombobox.value != "0") {
        productsData.forEach(p => {
            if(p.Manufacturer.name == filterCombobox.value) {
                _productsData.push(p)
            }
        })
    }
    else if(searchInput.value != "" && filterCombobox.value == "0") {
        productsData.forEach(p => {
            if(p.title.toLowerCase().includes(searchTerm) || p.description.toLowerCase().includes(searchTerm)) {
                _productsData.push(p)
            }
        })
    }
    else if(searchInput.value != "" && filterCombobox.value != "0") {
        productsData.forEach(p => {
            if((p.title.toLowerCase().includes(searchTerm) || p.description.toLowerCase().includes(searchTerm)) && p.Manufacturer.name == filterCombobox.value) {
                _productsData.push(p)
            }
        })
    }
    if(sortCombobox.value != 0) {
        if(sortCombobox.value == "asc") {
            _productsData.sort(compareFunctionASC)
        }
        else {
            _productsData.sort(compareFunctionDESC)
        }
    }
    renderAllProducts(_productsData)
}
function compareFunctionASC(a, b) {
    if(a.cost < b.cost) {
        return -1
    }
    if(a.cost > b.cost) {
        return 1
    }
    return 0
}
function compareFunctionDESC(a, b) {
    if(a.cost < b.cost) {
        return 1
    }
    if(a.cost > b.cost) {
        return -1
    }
    return 0
}
async function getAllProducts() { 
    const response = await fetch('http://localhost:3000/get-all-products')
    const data = await response.json()
    console.log(data)
    return data.data
}
async function getAllManufacturers() {
    const response = await fetch('http://localhost:3000/get-all-manufacturers')
    const data = await response.json()
    console.log(data)
    return data.data
}
async function getAllHistory() {
    const response = await fetch('http://localhost:3000/get-all-productsale')
    const data = await response.json()
    console.log(data)
    return data.data
}
function renderOneProduct(productObject) {
    const card = document.createElement("td")
    card.className = "card"
    card.dataset.id = productObject.id
    card.setAttribute("is-active", productObject.isActive)
    card.setAttribute("productId", productObject.id)
    card.innerHTML = `
    <td>
        <img src="assets/${productObject.mainImagePath}" productId="${productObject.id}"/>
        <h3 productId="${productObject.id}">${productObject.title}</h3>
        <p productId="${productObject.id}">Цена: ${productObject.cost}</p>
    </td>
    `
    card.addEventListener('click', event => {
        productId = (event.target.getAttribute("productId"));
        console.log('Выбранный ID из таблицы:', productId);
        fromtableproductid = productId
        
        console.log(event.target.parentNode)
        if (event.target.tagName = 'card') {
          var element = document.querySelector('.active')
          element && element.classList.remove('active')
          event.target.classList.add('active')
        }
    });
    
    productsTable.append(card)
}
function renderAllProducts(productsData) {
    productsTable.innerHTML = ""
    productsData.forEach(element => {
        renderOneProduct(element)
    });
}
function renderOneManufacturer(manufacturerObject, object) {
    const item = document.createElement("option")
    item.dataset.id = manufacturerObject.id
    item.innerHTML = `
    <option>${manufacturerObject.name}</option>
    `
    object.append(item)
}
function renderAllManufacturers(manufacturersData, object) {
    manufacturersData.forEach(element => {
        renderOneManufacturer(element, object)
    });

}
function renderAllProductsHistory(productsSalesData) {
    productsHistoryTable.innerHTML = `
    <thead>
                        <tr>
                            <th>Код продажи</th>
                            <th>Код продукта</th>
                            <th>Дата продажи</th>
                            <th>Количество</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                    </tbody>
    `
    console.log(productsSalesData)
    productsSalesData.forEach(element => {
        if(element.productId == fromtableproductid) {
            renderProductHistory(element)
        }
        
    });
}
function renderProductHistory(productSaleObject) {
    const row = document.createElement("tr");
            row.innerHTML = `
            <td>${productSaleObject.id}</td>
             <td>${productSaleObject.productId}</td>
             <td>${new Date(productSaleObject.saleDate).toLocaleString()}</td>
             <td>${productSaleObject.quantity}</td>
            `;
    productsHistoryTableBody.appendChild(row);
}

async function initialize(){
    console.log("start")
    productsArray = await getAllProducts()
    manufacturersArray = await getAllManufacturers()
    productsSalesArray = await getAllHistory()
    renderAllProducts(productsArray)
    renderAllManufacturers(manufacturersArray, filterCombobox)
}
initialize()