window.onload = function() {
    renderHistory();
};

async function sendExpr() {
    const expr = document.getElementById("expr").value;

    const response = await fetch("/calculate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ expression: expr, record: true })
    });

    if (response.ok) { // Всё ок, запрос корректно обработался сервером
        const data = await response.json();

        console.log(data);

        // Обновляем поле результата
        document.getElementById("result").textContent = data.value;

        // Обновляем историю в sessionStorage и на странице
        let history = JSON.parse(localStorage.getItem("history") || "[]");
        history.push({ expression: expr, result: data.value }); // Тут можно добавить преукрашения к строке выражения (чтобы, например, sqrt ззаменить на значок корня хз)
        localStorage.setItem("history", JSON.stringify(history));

        renderHistory();  // Функция, которая рендерит список
    } else { // обработка ошибки
        const data = await response.json();
        console.log(data);
        document.getElementById("result").textContent = "Ошибка: " + response.status + " Описание ошибки: " + data.message;
    }
}

function renderHistory() {
    const history = JSON.parse(localStorage.getItem("history") || "[]");
    const ul = document.getElementById("history");
    ul.innerHTML = "";
    history.forEach(item => {
        const li = document.createElement("li");
        li.textContent = `${item.expression} = ${item.result}`;
        ul.appendChild(li);
    });
}
