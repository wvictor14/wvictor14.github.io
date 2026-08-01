```{=html}
<div class="card-list list">
<% for (const item of items) { %>
  <div class="card-list-item" <%= metadataAttrs(item) %>>
    <% if (item.image) { %>
      <a href="<%- item.path %>" class="card-list-image">
        <img src="<%- item.image %>" alt="">
      </a>
    <% } %>
    <div class="card-list-body">
      <div class="card-list-date"><%= item.date %></div>
      <a href="<%- item.path %>" class="card-list-title"><%= item.title %></a>
      <% if (item.description) { %>
        <div class="card-list-description"><%= item.description %></div>
      <% } %>
      <% if (item.categories && item.categories.length) { %>
        <div class="card-list-categories">
        <% for (const category of item.categories) { %>
          <div class="listing-category"><%= category %></div>
        <% } %>
        </div>
      <% } %>
    </div>
  </div>
<% } %>
</div>
```
