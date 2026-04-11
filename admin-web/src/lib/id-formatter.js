/**
 * Formats an ID to 8 characters uppercase
 * Takes the first 8 characters of the ID and converts to uppercase
 * @param {string} id - The ID to format (can be GUID, UUID, or any string)
 * @returns {string} - The formatted ID (8 chars uppercase), or empty string if no ID provided
 */
export function formatStudentId(id) {
  if (!id) return '';
  return id.slice(0, 8).toUpperCase();
}

/**
 * Alias for formatStudentId for generic use
 */
export function formatId(id) {
  return formatStudentId(id);
}
