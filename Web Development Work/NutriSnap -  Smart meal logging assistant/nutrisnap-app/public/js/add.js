
function getMeals() {
  return JSON.parse(localStorage.getItem("meals") || "[]");
}
function saveMeals(meals) {
  localStorage.setItem("meals", JSON.stringify(meals));
}

document.addEventListener("DOMContentLoaded", function () {
  const editing = JSON.parse(localStorage.getItem("editingMeal"));
  if (editing) {
    document.getElementById("page-title").textContent = "Edit Meal";
    document.getElementById("meal-id").value = editing.id;
    document.getElementById("title").value = editing.title;
    document.getElementById("tags").value = editing.tags.join(", ");
    document.getElementById("calories").value = editing.calories;
    document.getElementById("description").value = editing.description;
    document.getElementById("satisfaction").value = editing.satisfaction;
    document.getElementById("image").value = editing.image || "";
    localStorage.removeItem("editingMeal");
  }
});

document.getElementById("meal-form").addEventListener("submit", function (e) {
  e.preventDefault();
  const id = document.getElementById("meal-id").value;
  const meal = {
    id: id ? parseInt(id) : Date.now(),
    title: document.getElementById("title").value,
    tags: document.getElementById("tags").value.split(",").map(t => t.trim()),
    calories: parseInt(document.getElementById("calories").value),
    description: document.getElementById("description").value,
    satisfaction: parseInt(document.getElementById("satisfaction").value),
    image: document.getElementById("image").value,
    date: new Date().toISOString(),
    userId: 1
  };
  const meals = getMeals();
  const updated = meals.some(m => m.id === meal.id)
    ? meals.map(m => m.id === meal.id ? meal : m)
    : [...meals, meal];
  saveMeals(updated);
  alert("Meal saved successfully!");
  window.location.href = "../index.html";
});

// document.addEventListener("DOMContentLoaded", function () {
//   const editing = JSON.parse(localStorage.getItem("editingMeal"));
//   const pageTitle = document.getElementById("page-title");
//   if (editing) {
//     pageTitle.textContent = "Edit Meal";
//   } else {
//     pageTitle.textContent = "Add New Meal";
//   }
// });
