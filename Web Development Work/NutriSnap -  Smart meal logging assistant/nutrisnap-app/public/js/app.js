
let isEdit = false;

async function initializeMeals() {
  const mealsFromStorage = localStorage.getItem("meals");
  if (!mealsFromStorage) {
    try {
      const response = await fetch("https://gist.githubusercontent.com/abdalabaaji/b858d603dd6215b6e93627a4f3eeb7f0/raw/21db65d8353957f910f4a4cf093ba9394dc45ca1/meals");
      const meals = await response.json();
      localStorage.setItem("meals", JSON.stringify(meals));
    } catch (error) {
      console.error("Failed to fetch meals from server:", error);
    }
  }
}

function getMeals() {
  return JSON.parse(localStorage.getItem("meals") || "[]");
}

function renderMeals(searchText = "") {
  const meals = getMeals();
  const container = document.getElementById("meals-list");
  if (!container) return;
  container.innerHTML = "";
  meals
    .filter(m => m.title.toLowerCase().includes(searchText.toLowerCase()))
    .forEach(meal => {
      const card = document.createElement("div");
      card.className = "card";
      card.innerHTML = `
        <img src="${meal.image || 'https://via.placeholder.com/150'}" alt="${meal.title}" class="meal-img"/>
        <div class="card-content">
          <h3>${meal.title}</h3>
          <p><strong>Date:</strong> ${new Date(meal.date).toLocaleString()}</p>
          <p><strong>Tags:</strong> ${meal.tags.map(tag => `<span class="tag">${tag}</span>`).join(" ")}</p>
          <p><strong>Calories:</strong> ${meal.calories} kcal</p>
          <p><strong>Satisfaction:</strong> <span class="stars">${'⭐'.repeat(meal.satisfaction)}</span></p>
          <button onclick="toggleDescription(this)">Show Description</button>
          <p class="description hidden">${meal.description}</p>
          <div class="actions-btns">
            <button onclick='editMeal(${JSON.stringify(meal)})' class="edit-btn">✏️ Edit</button>
            <button onclick='deleteMeal(${meal.id})' class="delete-btn">🗑️ Delete</button>
          </div>
        </div>
      `;
      container.appendChild(card);
    });
}
function deleteMeal(id) {
  if (!confirm("Are you sure you want to delete this meal?"))
    return;
  const meals = getMeals();
  const updatedMeals = meals.filter(meal => meal.id !== id);
  localStorage.setItem("meals", JSON.stringify(updatedMeals));
  renderMeals();
}

function toggleDescription(button) {
  const desc = button.nextElementSibling;
  if (desc.classList.contains("hidden")) {
    desc.classList.remove("hidden");
    button.textContent = "Hide Description";
  } else {
    desc.classList.add("hidden");
    button.textContent = "Show Description";
  }
}

function editMeal(meal) {
  isEdit = true;
  localStorage.setItem("editingMeal", JSON.stringify(meal));
  window.location.href = "pages/add.html";
}

document.addEventListener("DOMContentLoaded", async () => {
  await initializeMeals();
  renderMeals();

  const search = document.getElementById("search");
  if (search) {
    search.addEventListener("input", () => renderMeals(search.value));
  }
});
