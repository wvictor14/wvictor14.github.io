```{=html}
<div class="title-list list">
<% for (const item of items) { %>
  <div class="title-list-item" <%= metadataAttrs(item) %>>
    <div class="title-list-date"><%= item.date %></div>
    <div class="title-list-body">
      <a href="<%- item.path %>" class="title-list-title"><%= item.title %></a>
      <% if (item.categories && item.categories.length) { %>
        <div class="title-list-categories">
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
