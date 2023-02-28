walker init{
    title_length = 5;
    text = "I went on the road and I saw a really big truck.";
    list_of_text = text.str::split(" ");
    title = "";
    i=0;
    while i<title_length{
        title = title+" "+list_of_text[i];
        i+=1;
    }
    report title;
}