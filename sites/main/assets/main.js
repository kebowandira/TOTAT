function setLang(lang){
  document.documentElement.setAttribute('lang', lang);
  document.documentElement.setAttribute('data-lang', lang);
  document.querySelectorAll('.lang-btn').forEach(function(btn){
    btn.setAttribute('aria-pressed', btn.getAttribute('data-set') === lang ? 'true' : 'false');
  });
  try{ localStorage.setItem('totat-lang', lang); }catch(e){}
}

document.querySelectorAll('.lang-btn').forEach(function(btn){
  btn.addEventListener('click', function(){ setLang(btn.getAttribute('data-set')); });
});

(function(){
  var saved = null;
  try{ saved = localStorage.getItem('totat-lang'); }catch(e){}
  if(saved === 'en' || saved === 'id'){
    setLang(saved);
  }
})();
